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
        
        //ustawiam parametry dla obiektu trzymającego animacje
        animationObject.fadeInDuration = 0.2
        animationObject.fadeOutDuration = 0.2
        animationObject.usesSceneTimeBase = false
        animationObject.repeatCount = 0
        object = animationObject
         
        //wybieram jaka animacja powinna zostać załadowana na podstawie przesłanego parametru animationType
        switch animationType {
        case .walk:
            animationObject.repeatCount = Float.greatestFiniteMagnitude
            animationObject.speed = 2
            walkAnimation = animationObject
          
        case .dead:
            //animacja śmierci bohatera po wykonaniu ma odczekać 4 sekundy i zostać usunięta
            animationObject.isRemovedOnCompletion = true
            animationObject.duration = 4
            deadAnimation = animationObject
            animationObject.setValue("dead", forKey: "deadKey")
          
        case .attack:
            //po ukończeniu ataku animacja ataku zostaje usunięta
            animationObject.isRemovedOnCompletion = true
            animationObject.speed = 2
            animationObject.setValue("attack", forKey: "attackKey")
            attackAnimation = animationObject
        }
    }
}

extension PlayerAnimation: AnimationInterface {
    //ładuje animacje z podanym identyfikatorem ze ścieżek do katalogu
    func loadAnimations() {
        loadAnimation(animationType: .walk, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/idle", withIdentifier: "IdleID")
        loadAnimation(animationType: .dead, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/death", withIdentifier: "DeathID")
        loadAnimation(animationType: .attack, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/attackMagicVer2", withIdentifier: "AttackID")
    }
}
