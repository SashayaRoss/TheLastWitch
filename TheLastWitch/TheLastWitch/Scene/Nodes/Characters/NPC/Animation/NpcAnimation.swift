//
//  NpcAnimation.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class NpcAnimation {
    var walkAnimation = CAAnimation()
    var interactAnimation = CAAnimation()
    var object = CAAnimation()
    
    //
    var attackAnimation = CAAnimation()
    var deadAnimation = CAAnimation()
    
    func loadAnimation(animationType: NpcAnimationType, isSceneNamed scene: String, withIdentifier identifier: String) {
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
            
        case .interact:
            animationObject.isRemovedOnCompletion = false
            interactAnimation = animationObject
        }
    }
}
extension NpcAnimation: AnimationInterface {
    func loadAnimations() {
        loadAnimation(animationType: .walk, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/walk", withIdentifier: "WalkID")
        loadAnimation(animationType: .interact, isSceneNamed: "art.scnassets/Scenes/Characters/Enemies/Golem@Dead", withIdentifier: "Golem@Dead-1")
    }
}
