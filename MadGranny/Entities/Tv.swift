//
//  Tv.swift
//  MadGranny
//
//  Created by Ali on 16/12/23.
//

import SpriteKit
import GameplayKit

// 1
class Tv: GKEntity {
    
    let type: EntityType = .tv

  init( entityManager: EntityManager) {
    
    super.init()
    let texture = SKTexture(imageNamed: "tv")
      let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size(), entityType: type)
      
      // Creating a Physical body for it
      spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: spriteComponent.node.size.width + 10, height: spriteComponent.node.size.height + 10))
      spriteComponent.node.physicsBody?.isDynamic = true
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


