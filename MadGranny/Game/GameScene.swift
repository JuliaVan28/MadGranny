//
//  GameScene.swift
//  MadGranny
//
//  Created by Yuliia on 07/12/23.
//

import SpriteKit
import SwiftUI

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
    var child: Child?
    
    // Granny
    var granny: Granny?
    
    // AnalogJoystick
    var analogJoystick: AnalogJoystickEntity?
    
    
    //MARK: - SKScene override functions
    
    // When the view is presented
    override func didMove(to view: SKView) {
        // Create entity manager
        entityManager = EntityManager(scene: self)
        
        view.showsNodeCount = true
        /*
        // Add background
//        let background = SKSpriteNode(imageNamed: "mapBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        */
        self.setUpGame()
        
        self.setUpPhysicsWorld()
        
        // Adding the AnalogJoystick to the gameScene
       // self.setupJoystick()
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(entityManager.spawnCandy), SKAction.wait(forDuration: 10.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(entityManager.spawnCarrot), SKAction.wait(forDuration: 5.0)])))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
     
      
      if ((firstBody.categoryBitMask & PhysicsCategory.child != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.granny != 0)) {
        if let child = firstBody.node as? SKSpriteNode,
          let granny = secondBody.node as? SKSpriteNode {
            grannyDidCollideWithChild(granny: granny, child: child)
        }
      }
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
            
            // Creating Physics body and binding its contact
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
            spriteComponent.node.physicsBody?.isDynamic = true
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.child
            spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.granny
            spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            spriteComponent.node.constraints = [xConstraint, yConstraint]
            
            print("configured child")
        }
        if let child = child {
            print("added child")
            entityManager.add(child)
        }
        
        self.granny = Granny(entityManager: entityManager)
        if let spriteComponent = granny?.component(ofType: SpriteComponent.self) {
            let xRange = SKRange(lowerLimit: 0, upperLimit: frame.width)
            let xConstraint = SKConstraint.positionX(xRange)
            
            let yRange = SKRange(lowerLimit: 0, upperLimit: frame.height)
            let yConstraint = SKConstraint.positionY(yRange)
            
            spriteComponent.node.name = "granny"
            spriteComponent.node.zPosition = NodesZPosition.granny.rawValue
            spriteComponent.node.position = CGPoint(x: ScreenSize.width - ScreenSize.width/4, y: ScreenSize.height - ScreenSize.height/4)
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            
            // Creating Physics body and binding its contact
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size)
            spriteComponent.node.physicsBody?.isDynamic = true
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child
            spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.none
            spriteComponent.node.physicsBody?.usesPreciseCollisionDetection = true
            
            spriteComponent.node.constraints = [xConstraint, yConstraint]
            
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
        analogJoystick = AnalogJoystickEntity(entityManager: entityManager)
        if let analogJoystick = analogJoystick {
            entityManager.addJoyStick(analogJoystick)
        }
        
        analogJoystick?.joystickNode.trackingHandler = { [unowned self] data in
            if let child = entityManager.entities.first(where: {$0.component(ofType: SpriteComponent.self)?.entityType == .child}) {
                if var childPosition = child.component(ofType: SpriteComponent.self)?.node.position {
                    
                    childPosition = CGPoint(x: childPosition.x + (data.velocity.x * self.velocityMultiplier),
                                            y: childPosition.y + (data.velocity.y * self.velocityMultiplier))
                    child.component(ofType: SpriteComponent.self)?.node.position = childPosition
                }
            }
        }
    }
    
    private func setUpPhysicsWorld() {
//        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    private func restartGame() {
        self.gameLogic.restartGame()
    }
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
    
    func grannyDidCollideWithChild(granny: SKSpriteNode, child: SKSpriteNode) {
        print("Hit")
        gameLogic.isGameOver = true
    }
    
}
