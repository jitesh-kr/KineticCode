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
        VStack {
            Text("Right Arm ROM: \(Int(viewModel.currentArmAngle))°")
                .font(.headline)
                .padding()

            // SpriteKit View
            SpriteView(scene: scene)
                .frame(width: 300, height: 400)
                .cornerRadius(12)
                .onChange(of: viewModel.currentArmAngle) { newValue in
                    scene.updateWingPosition(angle: newValue)
                }
            
            Button("End Session") {
                showReport = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .sheet(isPresented: $showReport) {
            ReportView(maxAngle: viewModel.maxAngleAchieved)
        }
    }
}

