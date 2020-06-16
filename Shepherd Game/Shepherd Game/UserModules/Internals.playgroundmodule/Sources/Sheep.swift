import CoreGraphics

import SpriteKit
import UIKit
import PlaygroundSupport


class Sheep: SKSpriteNode {
	// The sheep is the main item of the game. It will follow the Boids algorithm rules.
	
    
    static var MAXSPEED: CGFloat = 3
    
    var vector: CGVector!
    var panicked: Bool = false
    var panickedTime = 0
    
    var textureOffset = 0
    var textures: [SKTexture] = []
    
    init() {
        let texturesNames = ["Goats/1.png","Goats/2.png","Goats/3.png","Goats/4.png"]
        textures = texturesNames.map{SKTexture(imageNamed: $0)}
        super.init(texture: textures.first, color: .clear, size: textures.first!.size())
        
        let a = Double.random(in: 0...(Double.pi*2))
        self.vector = CGVector(dx: cos(a), dy: sin(a))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    func Tick(neighbors: [Sheep], points: [CGPoint]) {
        // Update sheep poition
        if panickedTime > 0 {
            panickedTime -= 1
        }
        rule1(neighbors: neighbors)
        rule2(neighbors: neighbors)
        rule3(neighbors: neighbors)
        rule4(points: points)
        
        let absolute = vector.Abs
        if absolute > Sheep.MAXSPEED {
            vector.dx *= Sheep.MAXSPEED / absolute
            vector.dy *= Sheep.MAXSPEED / absolute
        }
        
        self.position.x += vector.dx
        self.position.y += vector.dy
        
        // Change texture
        textureOffset = (textureOffset + 1) % 20
        self.texture = textures[textureOffset / 5]
        
        // Rotate from vector
        var angle = atan2(vector.dy, vector.dx)
        self.zRotation = angle + CGFloat.pi * 1.5
    }
    
    func rule1(neighbors: [Sheep]) {
        if neighbors.isEmpty {
            return
        }
        var x: CGFloat = 0
        var y: CGFloat = 0
        for n in neighbors {
            x += n.position.x
            y += n.position.y
        }
        let mX = x / CGFloat(neighbors.count)
        let mY = y / CGFloat(neighbors.count)
        
        if self.panickedTime > 0 {
            vector.dx -= (mX - position.x) * 0.003
            vector.dy -= (mY - position.y) * 0.003
        } else {
            vector.dx += (mX - position.x) * 0.001
            vector.dy += (mY - position.y) * 0.001
        }
    }
    
    func rule2(neighbors: [Sheep]) {
        if neighbors.isEmpty {
            return
        }
        var x: CGFloat = 0
        var y: CGFloat = 0
        for n in neighbors {
            if position.Distance(from: n.position) < 50 {
                x += self.position.x - n.position.x
                y += self.position.y - n.position.y
            }
        }
        
        vector.dx += x * 0.01
        vector.dy += y * 0.01
    }
    
    func rule3(neighbors: [Sheep]) {
        if neighbors.isEmpty {
            return
        }
        var x: CGFloat = 0
        var y: CGFloat = 0
        for n in neighbors {
            x += n.vector.dx
            y += n.vector.dy
        }
        let mX = x / CGFloat(neighbors.count)
        let mY = y / CGFloat(neighbors.count)
        
        vector.dx += mX * 0.01
        vector.dy += mY * 0.01
    }
    
    
    func rule4(points: [CGPoint]) {
        // Run away from fence
        var x: CGFloat = 0
        var y: CGFloat = 0
        for n in points {
            if n.Distance(from: position) < 100 {
                x = n.x - position.x
                y = n.y - position.y
            }
        }
        vector.dx -= x * 0.01
        vector.dy -= y * 0.01
    }
}
