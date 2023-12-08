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


class GameScene: SKScene {
    /**
     * # The Game Logic
     *     The game logic keeps track of the game variables
     **/
    var gameLogic: GameLogic = GameLogic.shared
    
    // this will be used to accelerate the child
    let velocityMultiplier: CGFloat = 0.13
    
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    // The Z Position for the Child and the JoyStick on the screen
    enum NodesZPosition: CGFloat {
        case child, joystick
    }
    
    //MARK: - Characters
    
    // Child
    var child: SKSpriteNode =  {
        var sprite = SKSpriteNode(imageNamed: "child")
        sprite.position = CGPoint.zero
        sprite.zPosition = NodesZPosition.child.rawValue
        return sprite
    }()
    
    // Granny
    var granny: SKSpriteNode!
    
    
    //MARK: - Configuring the AnalogJoystick
    
    var analogJoystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: 100, colors: nil, images: (substrate: #imageLiteral(resourceName: "outterCircle"), stick: #imageLiteral(resourceName: "innerCircle")))
        js.position = CGPoint(x: ScreenSize.width * -0.235 + js.radius + 45, y: ScreenSize.height * -0.5 + js.radius + 35)
        js.zPosition = NodesZPosition.joystick.rawValue
        return js
    }()
    
    //MARK: - SKScene override functions
    
    // When the view is presented
    override func didMove(to view: SKView) {
        self.setUpGame()
        
        // Adding the AnalogJoystick to the gameScene
        self.setupJoystick()
        
        self.setUpPhysicsWorld()
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
        self.gameLogic.increaseSessionTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
    }
}

// MARK: - Game Scene Set Up
extension GameScene {
    
    private func setUpGame() {
        self.gameLogic.setUpGame()
        //  self.backgroundColor = SKColor.white
        
        // Anchoring the Child to the center of the screen
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Defining Playable area for the X-axis
        let xRange = SKRange(lowerLimit: -170, upperLimit: 170)
        let xConstraint = SKConstraint.positionX(xRange)
        
        // Defining Playable area for the Y-axis
        let yRange = SKRange(lowerLimit: -254, upperLimit: 275)
        let yConstraint = SKConstraint.positionY(yRange)
        
        // Defining Playable area for the child
        self.child.constraints = [xConstraint, yConstraint]
        
        addChild(child)
    }
    
//MARK: - setting up the analogJoyStick, take a look at the File AnalogJoystick insdie the Controller Folder
    // References: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/#
    
    func setupJoystick() {
        addChild(analogJoystick)
        analogJoystick.trackingHandler = { [unowned self] data in
            self.child.position = CGPoint(x: self.child.position.x + (data.velocity.x * self.velocityMultiplier),
                                          y: self.child.position.y + (data.velocity.y * self.velocityMultiplier))
        }
    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.9)
        //  physicsWorld.contactDelegate = self
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
    
}
