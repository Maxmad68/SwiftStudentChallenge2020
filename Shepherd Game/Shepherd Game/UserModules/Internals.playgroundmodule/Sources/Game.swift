//
//  GameInternals.swift
//  BookCore
//
//  Created by Maxime on 15/05/2020.
//

import Foundation
import SpriteKit
import PlaygroundSupport


public class ShepherdGame: SKScene {
    
    public static var NO_SHEEP_AT_START = 30
    public static var FENCE_LENGTH = 10
    static var defaultBackgroundColor: UIColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 1)
        
    var sheeps: [Sheep] = []
    var background: SKShapeNode!
    var sheepCounter: SKLabelNode!
    var lostLabel: SKLabelNode!
    
    var path: CGMutablePath? = nil
    var points: [CGPoint] = []
    var pathNode: SKShapeNode? = nil
    
    var beforeThunder: Int = 500
        
    override public init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .aspectFit
        self.backgroundColor = ShepherdGame.defaultBackgroundColor
        
        // Init bushes
        for i in 1...6 {
            let bush = Bush(scene: self)
            addChild(bush)
        }
        
        // Init Sheep counter
        self.sheepCounter = SKLabelNode.init(fontNamed: "AvenirNext-Bold")
        self.sheepCounter.fontSize = 48
        self.sheepCounter.fontColor = .black
        self.sheepCounter.position = .init(x: self.size.width / 2, y: self.size.height - self.sheepCounter.fontSize)
        self.addChild(sheepCounter)
        
        // Init "You Lose" text label
        self.lostLabel = SKLabelNode(text:"You Lose!")
        self.lostLabel.fontSize = 72
        self.lostLabel.fontColor = .white
        self.lostLabel.position = .init(x: self.size.width / 2, y: self.size.height + self.lostLabel.fontSize)
        self.addChild(self.lostLabel)
        
        //Init Thunder Background
        self.background = SKShapeNode.init(rect: frame)
        self.background.fillColor = .white
        self.background.alpha = 0 // Hide it at start
        self.addChild(self.background)
        
        // Spawn Sheeps
        for x in 1...ShepherdGame.NO_SHEEP_AT_START {
            let mouton = Sheep()
            self.AddSheep(mouton)
        }
        
        // Update counter
        UpdateCounter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override public func didMove(to view: SKView) {
        // Play sound ambiance at launch
        self.run(.repeatForever(.playSoundFileNamed("Sounds/Outdoor_Ambiance.mp3", waitForCompletion: true)))
    }
        
    func AddSheep(_ sheep: Sheep) {
        // Add a sheep to the game
        let xSpawn = CGFloat.random(in: (size.width * 0.25)...(size.width * 0.75))
        let ySpawn = CGFloat.random(in: (size.height * 0.25)...(size.height * 0.75))
        sheep.position = .init(x: xSpawn, y: ySpawn)
        sheeps.append(sheep)
        self.addChild(sheep)
    }
    
    func Thunder() {
        let backgroundAction = SKAction.sequence([
            .playSoundFileNamed("Sounds/rain.wav", waitForCompletion: false),
            .colorize(with: .darkGray, colorBlendFactor: 1, duration: 1.5)
        ])
        let thunderAction = SKAction.sequence([
            .wait(forDuration: 2.5),
            .playSoundFileNamed("Sounds/thunder.wav", waitForCompletion: false),
            .fadeIn(withDuration: 0.1),
            .fadeOut(withDuration: 0.4)
        ])
        // Add rain effect
        for i in 1...100 {
            let drop = Drop(scene: self)
            self.addChild(drop)
            drop.run()
        }
        self.run(backgroundAction, completion: {
            
            // Thunder "White screen"
            self.background.run(thunderAction, completion: {
                self.run(.stop())
                for sheep in self.sheeps { // Make sheeps panick
                    sheep.panickedTime = 100
                }
                // Go back to normal
                self.backgroundColor = ShepherdGame.defaultBackgroundColor
            })
        })
    }
        
    override public func update(_ currentTime: TimeInterval) {
        let minDistance = (size.width * 0.1)
        for sheep in sheeps {
            var neighbors: [Sheep] = sheeps.filter{$0 != sheep && $0.position.Distance(from: sheep.position) < minDistance} // Find closest neighbors
            if !sheep.intersects(self) {
                // Sheep needs to be removed from scene
                sheeps.removeAll(where: {$0 == sheep})
                sheep.removeFromParent()
                UpdateCounter()
            }
            sheep.Tick(neighbors: neighbors, points: points)
        }
        
        // Need to throw thunder?
        beforeThunder -= 1
        if beforeThunder <= 0 {
            beforeThunder = Int.random(in: 700...1300)
            Thunder()
        }
    }
    
    func UpdateCounter() {
        // Update sheep counter and test if lost
        let count = sheeps.count
        let string = "\(count)/\(ShepherdGame.NO_SHEEP_AT_START)"
        sheepCounter.text = string
        
        if count == 0 {
            Lose()
        }
    }
    
    func Lose() {
        // Display red screen if game lost
        let loseColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 0.7)
        let backgroundAction = SKAction.colorize(with: loseColor, colorBlendFactor: 1, duration: 0.6)
        let testAction = SKAction.moveTo(y: self.size.height / 2, duration: 0.6)
        let counterAction = SKAction.fadeOut(withDuration: 0.4)
        self.sheepCounter.run(counterAction)
        self.run(backgroundAction)
        self.lostLabel.run(testAction, completion: {
            PlaygroundPage.current.finishExecution()
        })
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        path = CGMutablePath()
        for t in touches{
            
            points.append((touches.first?.location(in: self))!)
        }
		// Keep only n last points (n = length of fence)
        points = points.suffix(ShepherdGame.FENCE_LENGTH)
        path?.move(to: points.first!)
        for point in points {
            path!.addLine(to: point)
        }
        pathNode!.path = path
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		// Destroy already existing fence
        if let alreadyExistingPathNode = pathNode {
            alreadyExistingPathNode.removeFromParent()
            points = []
        }
		
		// Add new point to fence
        points.append((touches.first?.location(in: self))!)
        self.path = CGMutablePath()
        pathNode = SKShapeNode.init(path: path!)
        pathNode!.fillColor = .clear
        pathNode!.strokeColor = .orange
        pathNode!.lineWidth = 7
        addChild(pathNode!)
    }
}
