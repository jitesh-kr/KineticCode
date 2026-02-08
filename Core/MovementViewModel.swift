//
//  MovementViewModel.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import Foundation
import Vision
import Combine

class MovementViewModel: ObservableObject {
    @Published var currentArmAngle: Double = 0.0
    @Published var maxAngleAchieved: Double = 0.0
    
    private let cameraManager = CameraManager()
    
    init() {
        cameraManager.onPoseDetected = { [weak self] joints in
            self?.processJoints(joints)
        }
    }
    
    private func processJoints(_ joints: [VNHumanBodyPoseObservation.JointName : CGPoint]) {
        guard let shoulder = joints[.rightShoulder],
              let elbow = joints[.rightElbow],
              let wrist = joints[.rightWrist] else { return }
        
        let angle = calculateAngle(p1: shoulder, p2: elbow, p3: wrist)
        
        self.currentArmAngle = angle
        if angle > maxAngleAchieved {
            maxAngleAchieved = angle
        }
    }
    
    // Calculates angle at P2 (Elbow)
    private func calculateAngle(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> Double {
        let v1 = CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
        let v2 = CGPoint(x: p3.x - p2.x, y: p3.y - p2.y)
        
        let angle1 = atan2(v1.y, v1.x)
        let angle2 = atan2(v2.y, v2.x)
        
        var angleDegrees = (angle1 - angle2) * 180 / .pi
        if angleDegrees < 0 { angleDegrees += 360 }
        
        return angleDegrees
    }
}

