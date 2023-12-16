//
//  Wall.swift
//  MadGranny
//
//  Created by Ali on 16/12/23.
//

import SpriteKit
import GameplayKit

// 1
class Wall: GKEntity {
    
    let type: EntityType = .wall

  init( entityManager: EntityManager) {
    
    super.init()
    let texture = SKTexture(imageNamed: "wall")
      let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size(), entityType: type)
      
      // Creating a Physical body for it
      spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: spriteComponent.node.size.width + 420, height: spriteComponent.node.size.height + 10))
      spriteComponent.node.physicsBody?.isDynamic = false
      spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.table
      spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child
      spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.child
      spriteComponent.node.physicsBody?.usesPreciseCollisionDetection = true

      
    addComponent(spriteComponent)
    addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(texture.size().width), entityManager: entityManager))
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

}

