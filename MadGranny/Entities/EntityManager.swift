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
    
    func spawnCandy() {
        let candy = Candy(entityManager: self)
        if let spriteComponent = candy.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGFloat.randomNumber(min: -150, max: 150), y: CGFloat.randomNumber(min: -350, max: 280))
            spriteComponent.node.setScale(0)
            spriteComponent.node.size = CGSize(width: 120, height: 120)
        }
        add(candy)
        
        if let spriteComponent = candy.component(ofType: SpriteComponent.self), let bonusComponentAction = candy.component(ofType: BonusComponent.self)?.twinkleActions {
            spriteComponent.node.run(SKAction.sequence(bonusComponentAction))
        }
    }
    
    func spawnCarrot() {
        let carrot = Carrot(entityManager: self)
        if let spriteComponent = carrot.component(ofType: SpriteComponent.self) {
            
            spriteComponent.node.position = CGPoint(x: CGFloat.randomNumber(min: -150, max: 150), y: CGFloat.randomNumber(min: -350, max: 280))
            spriteComponent.node.setScale(0)
            spriteComponent.node.size = CGSize(width: 120, height: 120)
        }
        add(carrot)
        
        if let spriteComponent = carrot.component(ofType: SpriteComponent.self), let bonusComponentAction = carrot.component(ofType: BonusComponent.self)?.twinkleActions {
            spriteComponent.node.run(SKAction.sequence(bonusComponentAction))
        }
    }
}
