//
//  GameScene.swift
//  MadGranny
//
//  Created by Yuliia on 07/12/23.
//

import SpriteKit
import SwiftUI
import UIKit

let generator = UIImpactFeedbackGenerator(style: .heavy)

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     **/
    var gameLogic: GameLogic = GameLogic.shared
    
    // Entity-component system
    var entityManager: EntityManager!
    
    // this will be used to accelerate the child
    var velocityMultiplier: CGFloat = 0.13
    
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
        print("DidMove is called")
        // Create entity manager
        entityManager = EntityManager(scene: self)
        
        view.showsNodeCount = true

        // Add background
        let background = SKSpriteNode(imageNamed: "mapBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        self.setUpGame()
        
        self.setUpPhysicsWorld()
        
        // Adding the AnalogJoystick to the gameScene
        self.setupJoystick()
        
        // Adding Obstacles to the Scene
        entityManager.spawnObstacle()
        
        //Spawning of bonus items every 5 sec
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(entityManager.spawnCandy), SKAction.wait(forDuration: 5.0)])))
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
        
        if ((firstBody.categoryBitMask & PhysicsCategory.child != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.carrot != 0)) {
          if let child = firstBody.node as? SKSpriteNode,
            let carrot = secondBody.node as? SKSpriteNode {
              childDidCollideWithCarrot(carrot: carrot, child: child)
          }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.child != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.candy != 0)) {
          if let child = firstBody.node as? SKSpriteNode,
            let candy = secondBody.node as? SKSpriteNode {
              childDidCollideWithCandy(candy: candy, child: child)
          }
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        
        // If the game over condition is met, the game will finish
        
// !!        if self.isGameOver { self.finishGame() }
        
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
        
        if gameLogic.isPaused {
            scene?.isPaused = true
            entityManager.pauseEntities()
            print("paused scene")
        }
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
            
            let yRange = SKRange(lowerLimit: 0, upperLimit: frame.height - 150)
            let yConstraint = SKConstraint.positionY(yRange)
            
            spriteComponent.node.name = "child"
            spriteComponent.node.size = CGSize(width: 35, height: 45)
//            spriteComponent.node.position = CGPoint.zero
            spriteComponent.node.position =  CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
            spriteComponent.node.zPosition = NodesZPosition.child.rawValue
            
            
            
            
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.child
            
            // Creating Physics body and binding its contact
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size)
            spriteComponent.node.physicsBody?.isDynamic = true
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.child
            spriteComponent.node.physicsBody?.allowsRotation = false
            spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.granny | PhysicsCategory.table | PhysicsCategory.chair
            spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.table | PhysicsCategory.plant | PhysicsCategory.chair
            
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
            
            let yRange = SKRange(lowerLimit: 0, upperLimit: frame.height - 150)
            let yConstraint = SKConstraint.positionY(yRange)
            
            spriteComponent.node.name = "granny"
            spriteComponent.node.zPosition = NodesZPosition.granny.rawValue
            
            
            
            spriteComponent.node.position = CGPoint(x: ScreenSize.width - ScreenSize.width/4, y: ScreenSize.height - ScreenSize.height/4)
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            
            // Creating Physics body and binding its contact
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size)
            spriteComponent.node.physicsBody?.isDynamic = true
            spriteComponent.node.physicsBody?.allowsRotation = false
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child | PhysicsCategory.table | PhysicsCategory.chair
            spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.table | PhysicsCategory.plant
            | PhysicsCategory.chair
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
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    private func restartGame() {
        gameLogic.isGameOver = false
    }
    
    func resumeGame() {
        entityManager.resumeEntities()
        scene?.isPaused = false
    }
}


// MARK: - Game Over Condition
extension GameScene {
    
    var isGameOver: Bool {
        return gameLogic.isGameOver
    }
    private func finishGame() {
        gameLogic.isGameOver = true
    }
}

//MARK: - Collisions
extension GameScene {
    
    func grannyDidCollideWithChild(granny: SKSpriteNode, child: SKSpriteNode) {
        generator.impactOccurred()
        print("Hit")
        
        // create the shape explosion
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = child.position
        
        let explodeAction = SKAction.run({
            self.addChild(explosion!)
            child.removeFromParent()
        })
        let wait = SKAction.wait(forDuration: 0.5)
        let removeExplodeAction = SKAction.run({explosion?.removeFromParent()})
        let explodeSequence = SKAction.sequence([explodeAction, wait, removeExplodeAction])
        
        self.run(explodeSequence)
        // finishGame()
    }
    
    func childDidCollideWithCarrot(carrot: SKSpriteNode, child: SKSpriteNode) {
        print("i ate \(carrot.name!)")
// <<<<<<< HEAD
        //        self.velocityMultiplier -= 0.01
        if self.velocityMultiplier > 0.05 {
            self.velocityMultiplier -= 0.01
        }
        carrot.removeFromParent()
        carrot.removeFromParent()
// =======
        if self.velocityMultiplier < 0.4 {
            self.velocityMultiplier += 0.01
        }
        print("velocity \(self.velocityMultiplier)")
      carrot.removeFromParent()
      carrot.removeFromParent()
        gameLogic.score(points: 15)

// >>>>>>> a5e7e306489e100c334ecab980c578cdab8958f8
    }
    
    func childDidCollideWithCandy(candy: SKSpriteNode, child: SKSpriteNode) {
        print("i ate \(candy.name!)")
        if self.velocityMultiplier > 0.05 {
            self.velocityMultiplier -= 0.01
        }
// <<<<<<< HEAD
        candy.removeFromParent()
        candy.removeFromParent()
// =======
        print("velocity \(self.velocityMultiplier)")
       candy.removeFromParent()
       candy.removeFromParent()
        gameLogic.score(points: 30)
// >>>>>>> a5e7e306489e100c334ecab980c578cdab8958f8
    }
}
