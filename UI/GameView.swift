//
//  GameView.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject private var viewModel = MovementViewModel()
    @State private var showReport = false
    
    // Initialize Scene
    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        ZStack {
            // Camera Preview Layer
            CameraPreview(cameraManager: viewModel.cameraManager)
                .ignoresSafeArea()
            
            VStack {
                Text("Right Arm ROM: \(Int(viewModel.currentArmAngle))°")
                    .font(.headline)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)

                // SpriteKit View (Transparent)
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .frame(width: 300, height: 400)
                    .background(Color.clear)
                    .onChange(of: viewModel.currentArmAngle) { newValue in
                        scene.updateWingPosition(angle: newValue)
                    }
                
                Button("End Session") {
                    showReport = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .sheet(isPresented: $showReport) {
            ReportView(sessionMaxAngle: viewModel.maxAngleAchieved)
        }
    }
}

