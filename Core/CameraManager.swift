//
//  CameraManager.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import AVFoundation
import Vision

// FIX: Add 'final' and '@unchecked Sendable' to silence the strict concurrency warning.
final class CameraManager: NSObject, ObservableObject, @unchecked Sendable, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    // Closure to send points back to ViewModel
    var onPoseDetected: (([VNHumanBodyPoseObservation.JointName : CGPoint]) -> Void)?

    override init() {
        super.init()
        setupCamera()
    }

    private func setupCamera() {
        // Setup input device (Front Camera)
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        if captureSession.canAddInput(input) { captureSession.addInput(input) }
        
        // Setup output
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) { captureSession.addOutput(videoOutput) }
        
        // Start session on a background thread to avoid blocking UI
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // FIX: The closure here captures 'self'. Since we marked the class @unchecked Sendable, this is now permitted.
        let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard let self = self else { return }
            
            guard let observation = request.results?.first as? VNHumanBodyPoseObservation,
                  let points = try? observation.recognizedPoints(.all) else { return }
            
            // Normalize points (Vision uses a flipped Y-axis compared to UIKit/SwiftUI)
            let normalizedPoints = points.mapValues { point in
                CGPoint(x: point.location.x, y: 1 - point.location.y)
            }
            
            // Dispatch to Main Actor/Thread for UI updates
            DispatchQueue.main.async {
                self.onPoseDetected?(normalizedPoints)
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
