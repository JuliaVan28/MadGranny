//
//  SpriteComponent.swift
//  MadGranny
//
//  Created by Yuliia on 09/12/23.
//

import Foundation
import SpriteKit
import GameplayKit


class SpriteComponent: GKComponent {

    let node: SKSpriteNode
    let entityType: EntityType

    init(entity: GKEntity, texture: SKTexture, size: CGSize, entityType: EntityType) {
    node = SKSpriteNode(texture: texture,
                        color: SKColor.white, size: size)
    self.entityType = entityType
        
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
