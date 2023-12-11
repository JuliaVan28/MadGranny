//
//  BonusComponent.swift
//  MadGranny
//
//  Created by Yuliia on 10/12/23.
//

import Foundation
import SpriteKit
import GameplayKit

class BonusComponent: GKComponent {
    let score: Int
    let waitTime: TimeInterval
    
    var twinkleActions: [SKAction]?
    
    init(score: Int, waitTime: TimeInterval = 5) {
      self.score = score
      self.waitTime = waitTime
        
      super.init()
        
        self.twinkleActions = setTwinkleActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTwinkleActions() -> [SKAction] {
        let apear = SKAction.scale(to: 1.0, duration: 0.5)
        let wait = SKAction.wait(forDuration: self.waitTime)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [apear, wait, disappear, removeFromParent]
        return actions
    }
}
