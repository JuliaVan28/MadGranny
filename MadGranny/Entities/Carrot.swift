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
    
    let type: EntityType = .child

  init( entityManager: EntityManager) {
    
    super.init()
    let texture = SKTexture(imageNamed: "carrot")
      let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size(), entityType: type)
      
    addComponent(spriteComponent)
    addComponent(MoveComponent(maxSpeed: 50, maxAcceleration: 0, radius: Float(texture.size().width), entityManager: entityManager))
    addComponent(BonusComponent(score: 40, waitTime: 8))
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

}
