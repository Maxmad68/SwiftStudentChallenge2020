//
//  Drop.swift
//  BookCore
//
//  Created by Maxime on 15/05/2020.
//

import Foundation
import SpriteKit

class Drop: SKSpriteNode {
	// A drop spawns at a random place when it rains and reproduce the appearance of a falling rain drop on the ground
	init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "drop.png")
        let size = CGSize(width: 1, height:1)
        super.init(texture: texture, color: .clear, size: size)
        
        // Spawn at random position
        let x = CGFloat.random(in: 0...scene.size.width)
        let y = CGFloat.random(in: 0...scene.size.height)
        self.position = .init(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run() {
		// Start animating the drop
        let waitBefore = Double.random(in: 0...3)
        let duration = TimeInterval(Double.random(in: 0...2))
        let endSize = CGFloat.random(in: 10...32)
        
        let actionGroup = SKAction.group([
            .resize(toWidth: endSize, height: endSize, duration: duration),
            .fadeOut(withDuration: duration),
            .rotate(byAngle: .pi / 4, duration: duration)
        ])
        let action = SKAction.sequence([
            .wait(forDuration:waitBefore),
            actionGroup
        ])
        self.run(action, completion: {
            self.removeFromParent()
            
        })
    }
}
