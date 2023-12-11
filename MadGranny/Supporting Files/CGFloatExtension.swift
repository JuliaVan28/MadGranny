//
//  CGFloatExtension.swift
//  MadGranny
//
//  Created by Yuliia on 10/12/23.
//

import Foundation

extension CGFloat {
    static func randomNumber() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    static func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.randomNumber() * (max - min) + min
    }
}
