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
    var grannyPositions: [CGPoint] = []
    var childPosition: CGPoint?
    var isPaused = false
    
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
            print("adding child to scene, it's position:")
            print(spriteNode.position)
            print(spriteNode.anchorPoint)
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
        grannyPositions.removeAll()
        isPaused = true
        // removes moveComponent from entities of type Granny
        for entity in entities {
            
            if let spriteNode = entity.component(ofType: SpriteComponent.self) {
                if spriteNode.entityType == .child {
                    childPosition = spriteNode.node.position
                    entities.remove(entity)
                    scene.removeChildren(in: [spriteNode.node])
                    print("paused child, it's moveComp position:")
                    print(entity.component(ofType: MoveComponent.self)?.position)
                } else if spriteNode.entityType == .granny {
                    print("found granny")
                  /* if let moveComponent = entity.component(ofType: MoveComponent.self) {
                       entity.removeComponent(ofType: MoveComponent.self)
                       for componentSystem in componentSystems {
                           componentSystem.removeComponent(foundIn: entity)
                       }

                       moveComponent.speed = 0
                       moveComponent.maxSpeed = 0
                       moveComponent.mass = 100
                       moveComponent.maxAcceleration = 0
                       grannyPositions.append(moveComponent.position)
                       moveComponent.behavior = nil
                      // GKBehavior(goal: GKGoal(toStayOn: GKPath(points: [SIMD2<Float>(moveComponent.position), SIMD2<Float>(moveComponent.position)], radius: 0.0, cyclical: true), maxPredictionTime: TimeInterval(1.0)), weight: 2)
                      // entity.addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: 0, entityManager: self))
                        //componentSystems.removeAll()
                        print("removed moveComponent")
                    }*/
                    print("paused granny, it's moveComp position:")
                    print(entity.component(ofType: MoveComponent.self)?.position)
                    grannyPositions.append(spriteNode.node.position)
                    entities.remove(entity)
                    scene.removeChildren(in: [spriteNode.node])
                }
                
            }
        }
      //  scene.isPaused = true
    }
    
    func resumeGrannies() {
        print("in resume")
        if let childPosition = childPosition {
            print("respawning child with position: \(childPosition)")
            spawnChild(position: childPosition)
        }
        
         for grannyPosition in grannyPositions {
         print(grannyPosition)
         print("spawning granny")
         spawnGrany(position: grannyPosition)
         }
        /*
        for entity in entities {
            
            if let spriteNode = entity.component(ofType: SpriteComponent.self) {
                if spriteNode.entityType == .granny {
                   // if let moveComponent = entity.component(ofType: MoveComponent.self) {
                      //  entity.removeComponent(ofType: MoveComponent.self)
                        entity.addComponent(MoveComponent(maxSpeed: 100, maxAcceleration: 80, radius: Float(spriteNode.node.texture!.size().width * 0.3), entityManager: self))
                    for componentSystem in componentSystems {
                        componentSystem.addComponent(foundIn: entity)
                    }
                        //componentSystems.removeAll()
//                        moveComponent.speed = 80
//                        moveComponent.maxSpeed = 100
//                        moveComponent.position = grannyPositions.removeFirst()
                       // moveComponent.behavior =
                        print("readded moveComponent")
                    //}
                }
            }
        }*/
        isPaused = false
    }
    
    func resumeEntities() {
        // adds moveComponent from entities of type Granny
        for entity in entities {
            if let spriteNode = entity.component(ofType: SpriteComponent.self) {
                if spriteNode.entityType == .granny {
                    print("found granny in resume Entities")
                    let movementComponent = MoveComponent(maxSpeed: 50, maxAcceleration: 80, radius: Float((spriteNode.node.texture?.size().width)! * 0.3), entityManager: self)
                    /*
                    // Find child
                      guard let child = entities.first(where: {$0.component(ofType: SpriteComponent.self)?.entityType == .child}),
                      let childMoveComponent = child.component(ofType: MoveComponent.self) else {
                      print("couldn't find child")
                          return
                    }
                    print(entities.filter({$0.component(ofType: SpriteComponent.self)?.entityType == .child}))
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

//MARK: - Spawn Entities
extension EntityManager {
    
    func addJoyStick(_ entity: AnalogJoystickEntity) {
        entities.insert(entity)
        scene.addChild(entity.joystickNode)
    }
    
    // MARK: Main Characters
    
    func spawnChild(position: CGPoint) {
        let child = Child(entityManager: self)
        if let spriteComponent = child.component(ofType: SpriteComponent.self) {
            let xRange = SKRange(lowerLimit: 0, upperLimit: scene.frame.width)
            let xConstraint = SKConstraint.positionX(xRange)
            
            let yRange = SKRange(lowerLimit: 0, upperLimit: scene.frame.height - 150)
            let yConstraint = SKConstraint.positionY(yRange)
            
            spriteComponent.node.name = "child"
            spriteComponent.node.size = CGSize(width: 25, height: 45)
//            spriteComponent.node.position = CGPoint.zero
            spriteComponent.node.position =  position 
            spriteComponent.node.zPosition = NodesZPosition.child.rawValue
            
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.child
            
            // Creating Physics body and binding its contact
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size)
            spriteComponent.node.physicsBody?.isDynamic = true
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.child
            spriteComponent.node.physicsBody?.allowsRotation = false
            spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.granny | PhysicsCategory.table | PhysicsCategory.chair
            spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.table | PhysicsCategory.plant | PhysicsCategory.chair
            
            spriteComponent.node.constraints = [xConstraint, yConstraint]
            
            print("configured child")
        }
            add(child)
    }
    
    func spawnGrany(position: CGPoint) {
        let granny = Granny(entityManager: self)
        if let spriteComponent = granny.component(ofType: SpriteComponent.self) {
            let xRange = SKRange(lowerLimit: 0, upperLimit: scene.frame.width)
            let xConstraint = SKConstraint.positionX(xRange)
            
            let yRange = SKRange(lowerLimit: 0, upperLimit: scene.frame.height - 150)
            let yConstraint = SKConstraint.positionY(yRange)
            
            spriteComponent.node.name = "granny"
            spriteComponent.node.zPosition = 0
            
            spriteComponent.node.position = position
                // spriteComponent.node.anchorPoint = CGPoint(x: 0, y: 0)
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            
            // Creating Physics body and binding its contact
            spriteComponent.node.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.node.size)
            spriteComponent.node.physicsBody?.isDynamic = true
            spriteComponent.node.physicsBody?.allowsRotation = false
            spriteComponent.node.physicsBody?.categoryBitMask = PhysicsCategory.granny
            spriteComponent.node.physicsBody?.contactTestBitMask = PhysicsCategory.child | PhysicsCategory.table | PhysicsCategory.plant | PhysicsCategory.chair | PhysicsCategory.granny
            spriteComponent.node.physicsBody?.collisionBitMask = PhysicsCategory.table | PhysicsCategory.plant | PhysicsCategory.chair | PhysicsCategory.granny
            spriteComponent.node.physicsBody?.usesPreciseCollisionDetection = true
            
            spriteComponent.node.constraints = [xConstraint, yConstraint]
            
            print("configured granny")
            print(spriteComponent.node.position)
            print(spriteComponent.node.anchorPoint)
        }
            print("added granny")
            add(granny)
       // print("Entities: \(self.entities)")
    }
    
    // MARK: Bonus Items
    private func spawnBonusItem(name: String, entity: GKEntity) {
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: CGFloat.randomNumber(min: 10,
                                                                            max: ScreenSize.width-10),
                                                    y: CGFloat.randomNumber(min: ScreenSize.height/8+20,
                                                                            max: ScreenSize.height-ScreenSize.height/8))
            spriteComponent.node.setScale(0)
            spriteComponent.node.size = CGSize(width: 120, height: 120)
            spriteComponent.node.name = name
            spriteComponent.node.zPosition = 4
            scene.addChild(spriteComponent.node)
        }
        entities.insert(entity)
        
        if let spriteComponent = entity.component(ofType: SpriteComponent.self),
           let bonusComponentAction = entity.component(ofType: BonusComponent.self)?.twinkleActions {
            spriteComponent.node.run(SKAction.sequence(bonusComponentAction))
        }
    }
    
    func spawnCandy() {
        let candy = Candy(entityManager: self)
        spawnBonusItem(name: "candy", entity: candy)
    }
    
    func spawnCarrot() {
        let carrot = Carrot(entityManager: self)
        spawnBonusItem(name: "carrot", entity: carrot)
        
    }
    
    // MARK: Obstacles
    func spawnObstacles() {
        let table = Table(entityManager: self)
        if let spriteComponent = table.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 , y: ScreenSize.height / 2 - 160)
            spriteComponent.node.size = CGSize(width: 85, height: 60)
            spriteComponent.node.name = "table"
            spriteComponent.node.zPosition = 5
        }
        add(table)
        
        let plantLeaningLeft = Plant(entityManager: self)
        if let spriteComponent = plantLeaningLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 160, y: ScreenSize.height / 2 + 240)
            spriteComponent.node.size = CGSize(width: 35, height: 40)
            spriteComponent.node.name = "plant"
            spriteComponent.node.zPosition = 5
        }
        add(plantLeaningLeft)
        
        let plantLeaningRight = Plant(entityManager: self)
        if let spriteComponent = plantLeaningRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 20, y: ScreenSize.height / 2 + 240)
            spriteComponent.node.size = CGSize(width: 35, height: 40)
            spriteComponent.node.name = "plant"
            spriteComponent.node.xScale = -1
            spriteComponent.node.zPosition = 5
        }
        add(plantLeaningRight)
        
        let chairFacingRight = ChairFacingRight(entityManager: self)
        if let spriteComponent = chairFacingRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 100, y: ScreenSize.height / 2 - 160)
            spriteComponent.node.size = CGSize(width: 30, height: 45)
            spriteComponent.node.name = "chair"
            spriteComponent.node.zPosition = 5
        }
        add(chairFacingRight)
        
        let chairFacingLeft = ChairFacingRight(entityManager: self)
        if let spriteComponent = chairFacingLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 + 100, y: ScreenSize.height / 2 - 160)
            spriteComponent.node.size = CGSize(width: 30, height: 45)
            spriteComponent.node.xScale = -1
            spriteComponent.node.name = "chair"
            spriteComponent.node.zPosition = 5

        }
        add(chairFacingLeft)

        
        let verticalwall = Wall(entityManager: self)
        if let spriteComponent = verticalwall.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 + 20 , y: ScreenSize.height / 2 + 235)
            spriteComponent.node.size = CGSize(width: 450, height: 10)
            spriteComponent.node.zRotation = 1.57
            spriteComponent.node.name = "wall"
            spriteComponent.node.zPosition = 5
         //   scene.addChild(spriteComponent.node)
        }
        add(verticalwall)
        
        let horizontalwall = Wall(entityManager: self)
        if let spriteComponent = horizontalwall.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 280 , y: ScreenSize.height / 2 + 15)
            spriteComponent.node.size = CGSize(width: 450, height: 10)
            spriteComponent.node.name = "wall"
            spriteComponent.node.zPosition = 5
         //   scene.addChild(spriteComponent.node)
        }
        add(horizontalwall)

        let tv = Tv(entityManager: self)
        if let spriteComponent = tv.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: ScreenSize.width / 2 - 90, y: ScreenSize.height / 2 + 240)
            spriteComponent.node.size = CGSize(width: 35, height: 35)
//            spriteComponent.node.zRotation = 1.57
            spriteComponent.node.name = "tv"
            spriteComponent.node.zPosition = 5
           // scene.addChild(spriteComponent.node)
        }
        add(tv)
    }
}
