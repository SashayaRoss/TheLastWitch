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
    
    func loadAnimation(animationType: PlayerAnimationType, isSceneNamed scene: String, withIdentifier identifier: String) {
        guard
            let sceneURL = Bundle.main.url(forResource: scene, withExtension: "dae"),
            let sceneSource = SCNSceneSource(url: sceneURL, options: nil),
            let animationObject: CAAnimation = sceneSource.entryWithIdentifier(identifier, withClass: CAAnimation.self)
        else {
            return
        }
        
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
            animationObject.isRemovedOnCompletion = true
            animationObject.duration = 4
            deadAnimation = animationObject
            animationObject.setValue("dead", forKey: "dead")
          
        case .attack:
            animationObject.isRemovedOnCompletion = true
            animationObject.setValue("attack", forKey: "animationId")
            attackAnimation = animationObject
        }
    }
}

extension PlayerAnimation: AnimationInterface {
    func loadAnimations() {
        loadAnimation(animationType: .walk, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/walk", withIdentifier: "WalkID")
        loadAnimation(animationType: .dead, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/die", withIdentifier: "DeathID")
        loadAnimation(animationType: .attack, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/attack", withIdentifier: "attackID")
    }
}
