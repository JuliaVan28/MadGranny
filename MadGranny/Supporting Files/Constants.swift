//
//  Constants.swift
//  MadGranny
//
//  Created by Yuliia on 10/12/23.
//

import Foundation
import SwiftUI

// Using the Device data to make sure that the AnalogJoystick always stays at the center of device
struct ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
    static let size         = CGSize(width: ScreenSize.width, height: ScreenSize.height)
}

typealias Instruction = (icon: String, title: String, description: String)
struct MainScreenProperties {
    static let gameTitle: String = "app-logo"
    
    static let gameInstructions: [Instruction] = [
        (icon: "controller-instruction", title: "lorem", description: "Use joystick to control the child."),
        (icon: "granny-instruction", title: "lorem", description: "Run from Granny."),
        (icon: "candy-instruction", title: "lorem", description: "Collect bonus items to get points."),
        (icon: "table", title: "lorem", description: "Use obstacles to save your life, some of them are mooveable."),
    ]
}

// Identifies SKSpriteNodes
struct PhysicsCategory {
    static let none: UInt32    = 0
    static let all: UInt32     = UInt32.max
    static let child: UInt32   = 0b1
    static let granny: UInt32  = 0b10
    static let carrot : UInt32 = 0b100
    static let candy  : UInt32 = 0b1000
    static let table: UInt32 = 0b10000
    static let plant: UInt32 = 0b100000
    static let chair: UInt32 = 0b1000000
    static let wall: UInt32 = 0b10000000
    static let tv: UInt32 = 0b100000000
}
