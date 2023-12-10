//
//  EntityManager.swift
//  MadGranny
//
//  Created by Yuliia on 09/12/23.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene
    
    lazy var componentSystems: [GKComponentSystem] = {
      let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
      return [moveSystem]
    }()
    
    
    init(scene: SKScene) {
      self.scene = scene
    }
    
    
    func add(_ entity: GKEntity) {
      entities.insert(entity)
      
      for componentSystem in componentSystems {
        componentSystem.addComponent(foundIn: entity)
      }
    
      if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
        scene.addChild(spriteNode)
      }
    
    }
    
    func remove(_ entity: GKEntity) {
    
      if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
        spriteNode.removeFromParent()
      }
      
      toRemove.insert(entity)
      entities.remove(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
      for componentSystem in componentSystems {
        componentSystem.update(deltaTime: deltaTime)
      }
      
      for curRemove in toRemove {
        for componentSystem in componentSystems {
          componentSystem.removeComponent(foundIn: curRemove)
        }
      }
      toRemove.removeAll()
    }
}
