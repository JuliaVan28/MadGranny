//
//  Carrot.swift
//  MadGranny
//
//  Created by Yuliia on 10/12/23.
//

import Foundation
import SpriteKit
import GameplayKit

class Carrot: GKEntity {
    
    let type: EntityType = .carrot
    
    init( entityManager: EntityManager) {
        
        super.init()
        let texture = SKTexture(imageNamed: "carrot")
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size(), entityType: type)
        
        // Creating a Physical body for it
        spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: spriteComponent.node.size.width/2, height: spriteComponent.node.size.height/2))
        spriteComponent.node.physicsBody?.isDynamic = true
        spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.carrot
        spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child
        spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.none
        spriteComponent.node.physicsBody?.usesPreciseCollisionDetection = true

        
        addComponent(spriteComponent)
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(texture.size().width), entityManager: entityManager))
        addComponent(BonusComponent(score: 40, waitTime: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
