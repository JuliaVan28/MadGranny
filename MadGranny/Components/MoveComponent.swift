//
//  MoveComponent.swift
//  MadGranny
//
//  Created by Yuliia on 09/12/23.
//

import Foundation
import SpriteKit
import GameplayKit

class MoveComponent : GKAgent2D, GKAgentDelegate {
    
    let entityManager: EntityManager
    
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.01
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            print("no spriteComponent in agentWillUpdate moveComponent")
            return
        }
        position = simd_float2(Float(spriteComponent.node.position.x), Float(spriteComponent.node.position.y))
        
        if spriteComponent.entityType == .granny {
            
            print("agentWillUpdate(_ agent: GKAgent) position: \(position)")
        }
        
        if entityManager.isPaused == false {
            // Find child and granny
            guard let child = entityManager.entities.first(where: {$0.component(ofType: SpriteComponent.self)?.entityType == .child})               else {
                print("couldn't find child")
                return
            }
            
            guard let childMoveComponent = child.component(ofType: MoveComponent.self) else {
                print("couldn't find child movement component")
                return
            }
            
            // Granny Move Component update
            if let granny = entityManager.entities.first(where: {$0.component(ofType: SpriteComponent.self)?.entityType == .granny}) {
                
                if let grannyMoveComponent = granny.component(ofType: MoveComponent.self) {
                    
                    var granniesMoveComp = [MoveComponent]()
                    print("before enity cycle in agentDidUpdate")
                    // get move components of all grannies
                    for entity in entityManager.entities {
                        if let spriteNode = entity.component(ofType: SpriteComponent.self) {
                            if spriteNode.entityType == .granny {
                                print("granny if agentDidupdate")
                                if let moveComp = entity.component(ofType: MoveComponent.self){
                                    granniesMoveComp.append(moveComp)
                                    print("appending grannyMoveComponent with position: \(moveComp.position)")
                                }
                            }
                        }
                    }
                    
                    let targetMoveComponent: GKAgent2D = childMoveComponent
                    
                    // Find obstacles to avoid
                    
                    // let obstaclesMoveComponents = entityManager.moveComponentsForObstacles()
                    // print(obstaclesMoveComponents)
                    //  let avoidGoal = GKGoal(toAvoid: obstaclesMoveComponents, maxPredictionTime: 10)
                    // behavior?.setWeight(200, for: avoidGoal)
                    
                    
                    // Set granny chasing behavior for all granies
                    granniesMoveComp.forEach({
                        $0.behavior = GKBehavior(goals: [
                            GKGoal(toSeekAgent: targetMoveComponent),
                            GKGoal(toReachTargetSpeed: maxSpeed)
                        ])
                    })
                    
                } else {
                    print("couldn't find granny movement component")
                } }  else {
                    print("couldn't find granny")
                }
        }
        
       
        
        
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            print("no spriteComponent in agentDidUpdate moveComponent")

            return
        }
        spriteComponent.node.position = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))

        if spriteComponent.entityType == .granny {
            print("agentDidUpdate(_ agent: GKAgent) position: \(spriteComponent.node.position)")
        }
       

    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        
        
        
        
    }
}
