//
//  Bush.swift
//  BookCore
//
//  Created by Maxime on 15/05/2020.
//

import Foundation
import SpriteKit

class Bush: SKSpriteNode {
	// A bush is a passive item of the background. It spawns at a random place and has no special behaviour
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: "bush.png")
        let size = CGSize(width: 64, height:64)
        super.init(texture: texture, color: .clear, size: size)
        let x = CGFloat.random(in: 0...scene.size.width)
        let y = CGFloat.random(in: 0...scene.size.height)
        self.position = .init(x: x, y: y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
