//
//  PlayerAnimation.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PlayerAnimation {
    var walkAnimation = CAAnimation()
    var attackAnimation = CAAnimation()
    var deadAnimation = CAAnimation()
    var object = CAAnimation()
    
    func loadAnimation(animationType:PlayerAnimationType, isSceneNamed scene:String, withIdentifier identifier:String) {
      
        let sceneURL = Bundle.main.url(forResource: scene, withExtension: "dae")!
        let sceneSource = SCNSceneSource(url: sceneURL, options: nil)!

        let animationObject:CAAnimation = sceneSource.entryWithIdentifier(identifier, withClass: CAAnimation.self)!
      
        animationObject.fadeInDuration = 0.2
        animationObject.fadeOutDuration = 0.2
        animationObject.usesSceneTimeBase = false
        animationObject.repeatCount = 0
        object = animationObject

        switch animationType {
          
        case .walk:
          animationObject.repeatCount = Float.greatestFiniteMagnitude
          walkAnimation = animationObject
          
        case .dead:
          animationObject.isRemovedOnCompletion = false
          deadAnimation = animationObject
          
        case .attack:
          animationObject.setValue("attack", forKey: "animationId")
          attackAnimation = animationObject
        }
    }
}

extension PlayerAnimation: AnimationInterface {
    func loadAnimations() {
        loadAnimation(animationType: .walk, isSceneNamed: "art.scnassets/Scenes/Hero/walk", withIdentifier: "WalkID")
        loadAnimation(animationType: .attack, isSceneNamed: "art.scnassets/Scenes/Hero/attack", withIdentifier: "attackID")
        loadAnimation(animationType: .dead, isSceneNamed: "art.scnassets/Scenes/Hero/die", withIdentifier: "DeathID")
    }
}
