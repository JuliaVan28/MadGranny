//
//  Table.swift
//  MadGranny
//
//  Created by Ali on 14/12/23.
//

import SpriteKit
import GameplayKit

// 1
class Table: GKEntity {
    
    let type: EntityType = .obstacle

  init( entityManager: EntityManager) {
    
    super.init()
    let texture = SKTexture(imageNamed: "table")
      let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size(), entityType: type)
      
      // Creating a Physical body for it
      spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 85, height: 60))
      spriteComponent.node.physicsBody?.isDynamic = false
      spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.table
      spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child | PhysicsCategory.chair
      spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.child | PhysicsCategory.chair
      spriteComponent.node.physicsBody?.usesPreciseCollisionDetection = true

      
    addComponent(spriteComponent)
    addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(texture.size().width), entityManager: entityManager))
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

}

