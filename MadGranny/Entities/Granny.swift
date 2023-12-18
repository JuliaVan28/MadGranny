//
//  Granny.swift
//  MadGranny
//
//  Created by Yuliia on 09/12/23.
//

import Foundation
import SpriteKit
import GameplayKit

class Granny: GKEntity {
let type: EntityType = .granny
    
  init( entityManager: EntityManager) {
    
    super.init()
    let texture = SKTexture(imageNamed: "big_granny")
      let spriteComponent = SpriteComponent(entity: self, texture: texture, size: CGSize(width: texture.size().width - 150, height: texture.size().height - 270), entityType: type)
      
    addComponent(spriteComponent)
    addComponent(MoveComponent(maxSpeed: 50, maxAcceleration: 80, radius: Float(texture.size().width * 0.3), entityManager: entityManager))
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

}
