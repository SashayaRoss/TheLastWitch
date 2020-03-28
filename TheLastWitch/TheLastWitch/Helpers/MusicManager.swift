//
//  MusicManager.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 21/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

final class MusicManager {
    var sounds: [String: SCNAudioSource] = [:]
    static let sharedInstance = MusicManager()
    
    func loadSound(name: String, fileNamed: String) {
      if let sound = SCNAudioSource(fileNamed: fileNamed) {
        sound.isPositional = false
        sound.volume = 0.3
        sound.load()
        sounds[name] = sound
      }
    }
    
    func playSound(node: SCNNode, name: String) {
      let sound = sounds[name]
      node.runAction(SCNAction.playAudio(sound!, waitForCompletion: false))
    }
}
