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
    var isExploded = false
    
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
            // print("added to the scene \(spriteNode.name)")
            scene.addChild(spriteNode)
        }
        
    }
    
    func addJoyStick(_ entity: AnalogJoystickEntity) {
        entities.insert(entity)
        scene.addChild(entity.joystickNode)
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
    
    func spawnGrany(position: CGPoint) {
        let granny = Granny(entityManager: self)
        if let spriteComponent = granny.component(ofType: SpriteComponent.self) {
            let xRange = SKRange(lowerLimit: 0, upperLimit: scene.frame.width)
            let xConstraint = SKConstraint.positionX(xRange)
            
            let yRange = SKRange(lowerLimit: 0, upperLimit: scene.frame.height - 150)
            let yConstraint = SKConstraint.positionY(yRange)
            
            spriteComponent.node.name = "granny"
            spriteComponent.node.zPosition = 1
            
            spriteComponent.node.position = position
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            
            // Creating Physics body and binding its contact
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size)
            spriteComponent.node.physicsBody?.isDynamic = true
            spriteComponent.node.physicsBody?.allowsRotation = false
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child | PhysicsCategory.table | PhysicsCategory.chair
            spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.table | PhysicsCategory.plant
            | PhysicsCategory.chair
            spriteComponent.node.physicsBody?.usesPreciseCollisionDetection = true
            
            spriteComponent.node.constraints = [xConstraint, yConstraint]
            
            print("configured granny")
            
        }
            print("added granny")
            add(granny)
        print("Entities: \(self.entities)")
    }
    
    func spawnCandy() {
        let candy = Candy(entityManager: self)
        if let spriteComponent = candy.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGFloat.randomNumber(min: 10, max: ScreenSize.width-10), y: CGFloat.randomNumber(min: ScreenSize.height/8+20, max: ScreenSize.height-ScreenSize.height/8))
            spriteComponent.node.setScale(0)
            spriteComponent.node.size = CGSize(width: 120, height: 120)
            spriteComponent.node.name = "candy"
            spriteComponent.node.zPosition = 4
            // print("configured candy")
            scene.addChild(spriteComponent.node)
        }
        entities.insert(candy)
        
        if let spriteComponent = candy.component(ofType: SpriteComponent.self), let bonusComponentAction = candy.component(ofType: BonusComponent.self)?.twinkleActions {
            spriteComponent.node.run(SKAction.sequence(bonusComponentAction))
        }
        // print(entities)
        //print("Scene node \(scene.childNode(withName: "candy")?.description)")
        
    }
    
    func spawnCarrot() {
        let carrot = Carrot(entityManager: self)
        if let spriteComponent = carrot.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGFloat.randomNumber(min: 10, max: ScreenSize.width-10), y: CGFloat.randomNumber(min: ScreenSize.height/8+20, max: ScreenSize.height-ScreenSize.height/8))
            spriteComponent.node.setScale(0)
            spriteComponent.node.size = CGSize(width: 120, height: 120)
            spriteComponent.node.name = "carrot"
            spriteComponent.node.zPosition = 4
            //  print("configured carrot")
            scene.addChild(spriteComponent.node)
            
        }
        entities.insert(carrot)
        
        if let spriteComponent = carrot.component(ofType: SpriteComponent.self), let bonusComponentAction = carrot.component(ofType: BonusComponent.self)?.twinkleActions {
            spriteComponent.node.run(SKAction.sequence(bonusComponentAction))
        }
        // print(entities)
        // print("Scene node \(scene.childNode(withName: "carrot")?.description)")
        
// <<<<<<< HEAD
// =======
    }
    
    func spawnObstacle() {
        let table = Table(entityManager: self)
        if let spriteComponent = table.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 , y: ScreenSize.height / 2 - 160)
            spriteComponent.node.size = CGSize(width: 85, height: 60)
            spriteComponent.node.name = "table"
            spriteComponent.node.zPosition = 5
            scene.addChild(spriteComponent.node)
            entities.insert(table)
        }
        
        let plantLeaningLeft = Plant(entityManager: self)
        if let spriteComponent = plantLeaningLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 160, y: ScreenSize.height / 2 + 240)
            spriteComponent.node.size = CGSize(width: 35, height: 40)
            spriteComponent.node.name = "plant"
            spriteComponent.node.zPosition = 5
            //  print("configured carrot")
            scene.addChild(spriteComponent.node)
            entities.insert(plantLeaningLeft)
        }
        
        let plantLeaningRight = Plant(entityManager: self)
        if let spriteComponent = plantLeaningRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 20, y: ScreenSize.height / 2 + 240)
            spriteComponent.node.size = CGSize(width: 35, height: 40)
            spriteComponent.node.name = "plant"
            spriteComponent.node.xScale = -1
            spriteComponent.node.zPosition = 5
            //  print("configured carrot")
            scene.addChild(spriteComponent.node)
            entities.insert(plantLeaningRight)
        }
        // chair is not added
        let chairFacingDown = ChairFacingDown(entityManager: self)
        if let spriteComponent = chairFacingDown.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 + 100, y: ScreenSize.height / 2 + 170)
            spriteComponent.node.size = CGSize(width: 30, height: 45)
            spriteComponent.node.name = "chair"
            spriteComponent.node.zPosition = 5
           // scene.addChild(spriteComponent.node)
           // entities.insert(chairFacingDown)
        }
        
        let chairFacingRight = ChairFacingRight(entityManager: self)
        if let spriteComponent = chairFacingRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 100, y: ScreenSize.height / 2 - 160)
            spriteComponent.node.size = CGSize(width: 30, height: 45)
            spriteComponent.node.name = "chair"
            spriteComponent.node.zPosition = 5
            //  print("configured carrot")
            scene.addChild(spriteComponent.node)
            entities.insert(chairFacingRight)
        }
        
        let chairFacingLeft = ChairFacingRight(entityManager: self)
        if let spriteComponent = chairFacingLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 + 100, y: ScreenSize.height / 2 - 160)
            spriteComponent.node.size = CGSize(width: 30, height: 45)
            spriteComponent.node.xScale = -1
            spriteComponent.node.name = "chair"
            spriteComponent.node.zPosition = 5
            //  print("configured carrot")
            scene.addChild(spriteComponent.node)
        }

        
        let verticalwall = Wall(entityManager: self)
        if let spriteComponent = verticalwall.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 + 20 , y: ScreenSize.height / 2 + 235)
            spriteComponent.node.size = CGSize(width: 450, height: 10)
            spriteComponent.node.zRotation = 1.57
            spriteComponent.node.name = "wall"
            spriteComponent.node.zPosition = 5
            //  print("configured carrot")
            scene.addChild(spriteComponent.node)
        }
        
        let horizontalwall = Wall(entityManager: self)
        if let spriteComponent = horizontalwall.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 280 , y: ScreenSize.height / 2 + 15)
            spriteComponent.node.size = CGSize(width: 450, height: 10)
            spriteComponent.node.name = "wall"
            spriteComponent.node.zPosition = 5
            //  print("configured carrot")
            scene.addChild(spriteComponent.node)
        }

        let tv = Tv(entityManager: self)
        if let spriteComponent = tv.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 90, y: ScreenSize.height / 2 + 240)
            spriteComponent.node.size = CGSize(width: 35, height: 35)
//            spriteComponent.node.zRotation = 1.57
            spriteComponent.node.name = "tv"
            spriteComponent.node.zPosition = 5
            //  print("configured carrot")
            scene.addChild(spriteComponent.node)
        }

        

// >>>>>>> a5e7e306489e100c334ecab980c578cdab8958f8
    }
    
    func moveComponentsForObstacles() -> [MoveComponent] {
        var moveComponents = [MoveComponent]()
        
        for entity in entities {
            if let spriteNode = entity.component(ofType: SpriteComponent.self) {
                if spriteNode.entityType == .obstacle {
                    if let moveComponent = entity.component(ofType: MoveComponent.self) {
                        moveComponents.append(moveComponent)
                    }
                }
            }
        }
        
        return moveComponents
    }
    
    func pauseEntities() {
        // removes moveComponent from entities of type Granny
        for entity in entities {
            if let spriteNode = entity.component(ofType: SpriteComponent.self) {
                if spriteNode.entityType == .granny {
                    print("found granny")
                    if entity.component(ofType: MoveComponent.self) != nil {
                        entity.removeComponent(ofType: MoveComponent.self)
                        componentSystems.removeAll()
                        print("removed moveComponent")
                    }
                }
            }
        }
    }
    
    func resumeEntities() {
        // adds moveComponent from entities of type Granny
        for entity in entities {
            if let spriteNode = entity.component(ofType: SpriteComponent.self) {
                if spriteNode.entityType == .granny {
                    print("found granny")
                    let movementComponent = MoveComponent(maxSpeed: 50, maxAcceleration: 80, radius: Float((spriteNode.node.texture?.size().width)! * 0.3), entityManager: self)
                   /* // Find child
                      guard let child = entities.first(where: {$0.component(ofType: SpriteComponent.self)?.entityType == .child}),
                      let childMoveComponent = child.component(ofType: MoveComponent.self) else {
                      print("couldn't find child")
                          return
                    }
                    
                    let targetMoveComponent: GKAgent2D = childMoveComponent
                      
                    // Set behavior
                    movementComponent.behavior = GKBehavior(goals: [GKGoal(toSeekAgent: targetMoveComponent), GKGoal(toReachTargetSpeed: 1.0)])
                    */
                    
                    entity.addComponent(movementComponent)
                    componentSystems.append(GKComponentSystem(componentClass: MoveComponent.self))
                    
                    for componentSystem in componentSystems {
                        componentSystem.addComponent(foundIn: entity)
                    }
                    
                    print("move Component is added")
                    //self.update(0.1)
                }
            }
        }
    }
}
