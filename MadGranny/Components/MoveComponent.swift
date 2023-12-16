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
       // print("mass: \(self.mass)")
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
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
      guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
        return
      }

        spriteComponent.node.position = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
    }
    
    override func update(deltaTime seconds: TimeInterval) {

      super.update(deltaTime: seconds)
     
        
      // Find child
        guard let child = entityManager.entities.first(where: {$0.component(ofType: SpriteComponent.self)?.entityType == .child}),
        let childMoveComponent = child.component(ofType: MoveComponent.self), let granny = entityManager.entities.first(where: {$0.component(ofType: SpriteComponent.self)?.entityType == .granny}), let grannyMoveComponent = granny.component(ofType: MoveComponent.self) else {
        print("couldn't find child")
            return
      }
      
      let targetMoveComponent: GKAgent2D = childMoveComponent
        
      // Find obstacles to avoid
      let obstaclesMoveComponents = entityManager.moveComponentsForObstacles()
       // print(obstaclesMoveComponents)
        let avoidGoal = GKGoal(toAvoid: obstaclesMoveComponents, maxPredictionTime: 10)
      
      // Set behavior
        grannyMoveComponent.behavior = GKBehavior(goals: [GKGoal(toSeekAgent: targetMoveComponent), GKGoal(toReachTargetSpeed: maxSpeed)])
       // behavior?.setWeight(200, for: avoidGoal)

    }
}
