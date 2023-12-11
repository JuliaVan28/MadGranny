//
//  AnalogJoystick.swift
//  MadGranny
//
//  Created by Yuliia on 10/12/23.
//

import Foundation
import SpriteKit
import GameplayKit

class AnalogJoystickEntity: GKEntity {
    
    var joystickNode: AnalogJoystick
    
    init( entityManager: EntityManager) {
        joystickNode = AnalogJoystick(diameter: 100, colors: nil, images: (substrate: #imageLiteral(resourceName: "outterCircle"), stick: #imageLiteral(resourceName: "innerCircle")))
        joystickNode.name = "joystick"
        joystickNode.position = CGPoint(x: ScreenSize.width/2,  y: ScreenSize.height/8 )
        joystickNode.zPosition = 5

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
