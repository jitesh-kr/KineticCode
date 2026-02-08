//
//  GameScene.swift
//  KineticCode
//
//  Created by Jitesh Kumar on 07/02/26.
//

import SpriteKit

class GameScene: SKScene {
    // Create a simple bird sprite
    let bird = SKSpriteNode(color: .yellow, size: CGSize(width: 50, height: 50))
    
    override func didMove(to view: SKView) {
        // FIX: Use .cyan or a custom color literal, as .skyBlue does not exist
        backgroundColor = .cyan
        
        bird.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(bird)
    }
    
    func updateWingPosition(angle: Double) {
        // Map 0-180 degree arm angle to bird rotation
        // -90 ensures 0 degrees (arm down) points the bird down/neutral
        let rotation = CGFloat(angle - 90) * (.pi / 180)
        let moveAction = SKAction.rotate(toAngle: rotation, duration: 0.1)
        bird.run(moveAction)
    }
}
