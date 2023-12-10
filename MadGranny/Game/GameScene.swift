//
//  GameScene.swift
//  MadGranny
//
//  Created by Yuliia on 07/12/23.
//

import SpriteKit
import SwiftUI

// Using the Device data to make sure that the AnalogJoystick always stays at the center of device
struct ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
    static let size         = CGSize(width: ScreenSize.width, height: ScreenSize.height)
}

// Identifies SKSpriteNodes
struct PhysicsCategory {
    static let none: UInt32    = 0
    static let all: UInt32     = UInt32.max
    static let child: UInt32   = 0b1
    static let granny: UInt32  = 0b10
}

//  Extension
extension CGFloat {
    static func randomNumber() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    static func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.randomNumber() * (max - min) + min
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     **/
    var gameLogic: GameLogic = GameLogic.shared
    
    // Entity-component system
    var entityManager: EntityManager!
    
    // this will be used to accelerate the child
    let velocityMultiplier: CGFloat = 0.13
    
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    // The Z Position for the Child and the JoyStick on the screen
    enum NodesZPosition: CGFloat {
        case child, granny, joystick
    }
    
    //MARK: - Characters
    
    // Child
    /*
     var child: SKSpriteNode =  {
     var sprite = SKSpriteNode(imageNamed: "child")
     sprite.position = CGPoint.zero
     sprite.zPosition = NodesZPosition.child.rawValue
     return sprite
     }()*/
    
    var child: Child?
    
    // Granny
    // var granny: SKSpriteNode!
    
    var granny: Granny?
    
    
    //MARK: - Configuring the AnalogJoystick
    
    var analogJoystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: 100, colors: nil, images: (substrate: #imageLiteral(resourceName: "outterCircle"), stick: #imageLiteral(resourceName: "innerCircle")))
        js.name = "joystick"
        js.position = CGPoint(x: ScreenSize.width * -0.235 + js.radius + 45, y: ScreenSize.height * -0.5 + js.radius + 45)
        js.zPosition = NodesZPosition.joystick.rawValue
        return js
    }()
    
    //MARK: - SKScene override functions
    
    // When the view is presented
    override func didMove(to view: SKView) {
        // Create entity manager
        entityManager = EntityManager(scene: self)
        
        self.setUpGame()
        
        self.setUpPhysicsWorld()
    
        // Adding the AnalogJoystick to the gameScene
        self.setupJoystick()
            
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnCandy), SKAction.wait(forDuration: 10.0)])))
    }
    
    func spawnCandy() {
        let candy = SKSpriteNode(imageNamed: "candy")
        let carrot = SKSpriteNode(imageNamed: "carrot")
        candy.position = CGPoint(x: CGFloat.randomNumber(min: -150, max: 150), y: CGFloat.randomNumber(min: -350, max: 280))
        carrot.position = CGPoint(x: CGFloat.randomNumber(min: -150, max: 150), y: CGFloat.randomNumber(min: -350, max: 280))
        candy.setScale(0)
        carrot.setScale(0)
        candy.size = CGSize(width: 120, height: 120)
        carrot.size = CGSize(width: 120, height: 120)
        addChild(candy)
        addChild(carrot)
        
        let apear = SKAction.scale(to: 1.0, duration: 0.5)
        let wait = SKAction.wait(forDuration: 5)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [apear, wait, disappear, removeFromParent]
        candy.run(SKAction.sequence(actions))
        carrot.run(SKAction.sequence(actions))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // If the game over condition is met, the game will finish
        if self.isGameOver { self.finishGame() }
        
        // The first time the update function is called we must initialize the
        // lastUpdate variable
        if self.lastUpdate == 0 { self.lastUpdate = currentTime }
        
        // Calculates how much time has passed since the last update
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
       
        // Increments the length of the game session at the game logic
        // self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
        
        //Update Components in entityManager
        entityManager.update(timeElapsedSinceLastUpdate)
        
    }
}

// MARK: - Game Scene Set Up
extension GameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        
        setUpCharacters()
    }
    
    private func setUpCharacters() {
        self.child = Child(entityManager: entityManager)
        if let spriteComponent = child?.component(ofType: SpriteComponent.self) {
            let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width)
            let xConstraint = SKConstraint.positionX(xRange)
            
            let yRange = SKRange(lowerLimit: 0, upperLimit: frame.height)
            let yConstraint = SKConstraint.positionY(yRange)
            
            spriteComponent.node.name = "child"
            spriteComponent.node.position = CGPoint.zero
            spriteComponent.node.position =  CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
            spriteComponent.node.zPosition = NodesZPosition.child.rawValue
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.child
            
            spriteComponent.node.constraints = [xConstraint, yConstraint]

            print("configured child")
        }
        if let child = child {
            print("added child")
            entityManager.add(child)
        }
        
        self.granny = Granny(entityManager: entityManager)
        if let spriteComponent = granny?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.name = "granny"
            spriteComponent.node.zPosition = NodesZPosition.granny.rawValue
            spriteComponent.node.position = CGPoint(x: ScreenSize.width - ScreenSize.width/4, y: ScreenSize.height - ScreenSize.height/4)
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            print("configured granny")

        }
        if let granny = granny {
            print("added granny")
            entityManager.add(granny)
        }
        
        
        
        print("Entities: \(entityManager.entities)")
        
    }
    
    //MARK: - setting up the analogJoyStick, take a look at the File AnalogJoystick insdie the Controller Folder
// References: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/#
        
        func setupJoystick() {
            addChild(analogJoystick)
            print(scene?.childNode(withName: "joystick")?.description)
            
            analogJoystick.trackingHandler = { [unowned self] data in
                if let child = entityManager.entities.first(where: {$0.component(ofType: SpriteComponent.self)?.entityType == .child}) {
                    print("unwrapped child for joystick tracking handler")
                    if var childPosition = child.component(ofType: SpriteComponent.self)?.node.position {
                        print("unwrapped child's position")
                        
                        childPosition = CGPoint(x: childPosition.x + (data.velocity.x * self.velocityMultiplier),
                                                y: childPosition.y + (data.velocity.y * self.velocityMultiplier))
                        child.component(ofType: SpriteComponent.self)?.node.position = childPosition
                    }
                }
            }
        }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        physicsWorld.contactDelegate = self
    }
    
    private func restartGame() {
        self.gameLogic.restartGame()
    }
}

//MARK: - Granny Set up and Logic
//SpriteKit way
extension GameScene {
    
    /*
     private func createGranny(at position: CGPoint) {
     let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width)
     let xConstraint = SKConstraint.positionX(xRange)
     
     let yRange = SKRange(lowerLimit: 0, upperLimit: frame.height)
     let yConstraint = SKConstraint.positionY(yRange)
     
     //TODO: Change to granny image
     self.granny = SKSpriteNode(imageNamed: "child")
     self.granny.name = "granny"
     self.granny.zPosition = NodesZPosition.granny.rawValue
     
     self.granny.position = position
     
     
     self.granny.physicsBody = SKPhysicsBody(circleOfRadius: 100.0)
     self.granny.physicsBody?.affectedByGravity = false
     
     self.granny.physicsBody?.categoryBitMask = PhysicsCategory.granny
     
     //TODO: add contactTestBitMask and collisionBitMask
     
     self.granny.constraints = [xConstraint, yConstraint]
     
     addChild(self.granny)
     
     }*/
    /*
     private func moveGrannyToChild(_ granny: SKSpriteNode ) {
     let location = self.child.position
     
     // Aim
     let dx = location.x - granny.position.x
     let dy = location.y - granny.position.y
     let angle = atan2(dy, dx)
     
     granny.zRotation = angle
     
     // Seek
     let vx = cos(angle) * grannySpeed
     let vy = sin(angle) * grannySpeed
     
     granny.position.x += vx
     granny.position.y += vy
     }
     */
    
}

// MARK: - Game Over Condition
extension GameScene {
    
    /**
     * Implement the Game Over condition.
     * Remember that an arcade game always ends! How will the player eventually lose?
     *
     * Some examples of game over conditions are:
     * - The time is over!
     * - The player health is depleated!
     * - The enemies have completed their goal!
     * - The screen is full!
     **/
    
    var isGameOver: Bool {
        // TODO: Customize!
        
        // Did you reach the time limit?
        // Are the health points depleted?
        // Did an enemy cross a position it should not have crossed?
        
        return gameLogic.isGameOver
    }
    
    private func finishGame() {
        gameLogic.isGameOver = true
    }
    
}
