//
//  EnemyAnimation.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 08/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class EnemyAnimation {
    var walkAnimation = CAAnimation()
    var attackAnimation = CAAnimation()
    var deadAnimation = CAAnimation()
    var object = CAAnimation()
    
    func loadAnimation(animationType: EnemyAnimationType, isSceneNamed scene: String, withIdentifier identifier: String) {
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
            animationObject.isRemovedOnCompletion = false
            deadAnimation = animationObject
            
        case .attack:
            animationObject.setValue("attack", forKey: "animationId")
            attackAnimation = animationObject
        }
    }
}

extension EnemyAnimation: AnimationInterface {
    func loadAnimations() {
        loadAnimation(animationType: .walk, isSceneNamed: "art.scnassets/Scenes/Characters/Enemies/werewolfWalksInPlace", withIdentifier: "WalkWolfID")
        loadAnimation(animationType: .dead, isSceneNamed: "art.scnassets/Scenes/Characters/Enemies/werewolfDeath", withIdentifier: "DeathWolfID")
        loadAnimation(animationType: .attack, isSceneNamed: "art.scnassets/Scenes/Characters/Enemies/werewolfAttack", withIdentifier: "AttackWolfID")
    }
}
