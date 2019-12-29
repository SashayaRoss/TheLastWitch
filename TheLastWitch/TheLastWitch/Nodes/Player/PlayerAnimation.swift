//
//  PlayerAnimation.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PlayerAnimation {
    
    private var walkAnimation = CAAnimation()
    private var attackAnimation = CAAnimation()
    private var deadAnimation = CAAnimation()
    
    func loadAnimations() {
        loadAnimation(animationType: .walk, inSceneNames: "art.scnassets/Scenes/Hero/walk", withIdentifier: "WalkID")
        loadAnimation(animationType: .attack, inSceneNames: "art.scnassets/Scenes/Hero/attack", withIdentifier: "AttackID")
        loadAnimation(animationType: .dead, inSceneNames: "art.scnassets/Scenes/Hero/dead", withIdentifier: "DeathID")
    }
    
    private func loadAnimation(animationType: PlayerAnimationType, inSceneNames scene: String, withIdentifier identifier: String) {
        guard let sceneURL = Bundle.main.url(forResource: scene, withExtension: "dae") else { return }
        guard let sceneSource = SCNSceneSource(url: sceneURL, options: nil) else { return }
        
        guard let animationObject: CAAnimation = sceneSource.entryWithIdentifier(identifier, withClass: CAAnimation.self) else { return }
        
//        animationObject.delegate = self
        animationObject.fadeInDuration = 0.2
        animationObject.fadeOutDuration = 0.2
        animationObject.usesSceneTimeBase = false
        animationObject.repeatCount = 0
        
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
