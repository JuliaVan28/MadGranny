//
//  Candy.swift
//  MadGranny
//
//  Created by Yuliia on 10/12/23.
//

import Foundation
import SpriteKit
import GameplayKit

class Candy: GKEntity {
    
    let type: EntityType = .candy

  init( entityManager: EntityManager) {
    
    super.init()
    let texture = SKTexture(imageNamed: "candy")
      let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size(), entityType: type)
      
      // Creating a Physical body for it
      spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size)
      spriteComponent.node.physicsBody?.isDynamic = true
      spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.carrot
      spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child
      spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.none
      spriteComponent.node.physicsBody?.usesPreciseCollisionDetection = true
      
    addComponent(spriteComponent)
    addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(texture.size().width), entityManager: entityManager))
    addComponent(BonusComponent(score: 20))
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

}
