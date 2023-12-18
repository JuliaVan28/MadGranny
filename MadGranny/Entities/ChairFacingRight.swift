//
//  ChairFacingRight.swift
//  MadGranny
//
//  Created by Ali on 15/12/23.
//

import SpriteKit
import GameplayKit

class ChairFacingRight: GKEntity {
    
    let type: EntityType = .obstacle

  init( entityManager: EntityManager) {
    
    super.init()
    let texture = SKTexture(imageNamed: "chairFacingRight")
      let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size(), entityType: type)
      
      // Creating a Physical body for it
      spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 40))
      spriteComponent.node.physicsBody?.isDynamic = true
      spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.chair
      spriteComponent.node.physicsBody?.allowsRotation = false
      spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child | PhysicsCategory.table
      spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.child | PhysicsCategory.table
      spriteComponent.node.physicsBody?.usesPreciseCollisionDetection = true

      
    addComponent(spriteComponent)
    addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(texture.size().width), entityManager: entityManager))
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

}


