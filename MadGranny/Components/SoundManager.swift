//
//  SoundManager.swift
//  MadGranny
//
//  Created by Yuliia on 18/12/23.
//

import Foundation
import SpriteKit

class SoundManager {

  let soundCollect = SKAction.playSoundFileNamed("collect.mp3", waitForCompletion: false)
  let soundExplode = SKAction.playSoundFileNamed("explode.mp3", waitForCompletion: false)
  let soundBackground = SKAction.playSoundFileNamed("background.mp3", waitForCompletion: false)
  
  static let sharedInstance = SoundManager()

}
