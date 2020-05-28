//
//  MusicManager.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 21/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

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
        let effect = sounds[name]
        guard let sound = effect else { return }
        
        node.runAction(SCNAction.playAudio(sound, waitForCompletion: false))
    }
    
    func playTheme(scene: SCNScene, directory: String) {
        let theme = SCNAudioSource(fileNamed: directory)
        
        guard let soundtrack = theme else { return }
        soundtrack.volume = 0.3
        let musicPlayer = SCNAudioPlayer(source: soundtrack)
        soundtrack.loops = true
        soundtrack.shouldStream = true
        soundtrack.isPositional = false
        
        scene.rootNode.addAudioPlayer(musicPlayer)
    }
    
    func loadSounds() {
        loadSound(name: "Magic", fileNamed: "art.scnassets/Audio/MagicTmp.wav")
        loadSound(name: "GameOver", fileNamed: "art.scnassets/Audio/GameOverTmp.wav")
    }
    
    func removeAllPlayers(scene: SCNScene) {
        scene.rootNode.removeAllAudioPlayers()
    }
}
