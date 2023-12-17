//
//  Plant.swift
//  MadGranny
//
//  Created by Ali on 14/12/23.
//

import SpriteKit
import GameplayKit

class Plant: GKEntity {
    
    let type: EntityType = .obstacle

  init( entityManager: EntityManager) {
    
    super.init()
    let texture = SKTexture(imageNamed: "plant")
      let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size(), entityType: type)
      
      // Creating a Physical body for it
      spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 35))
      spriteComponent.node.physicsBody?.isDynamic = true
      spriteComponent.node.physicsBody?.allowsRotation = false
      spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.plant
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

