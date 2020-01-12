//
//  Enemy.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/01/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

enum EnemyAnimationType {
    case walk
    case attack1
    case dead
}

final class Enemy: SCNNode {
    
    //general
    var gameView: GameView!
    
    //nodes
    private let daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var enemy: Player!
    
    private var walkAnimation = CAAnimation()
    private var deadAnimation = CAAnimation()
    private var attack1Animation = CAAnimation()
    
    //MARK: init
    init(enemy: Player, view: GameView) {
        super.init()
        
        self.gameView = view
        self.enemy = enemy
        
        setupModelScene()
        loadAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: scene
    private func setupModelScene() {
        name = "Wolf"
        let idleURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Enemies/Golem@Idle", withExtension: "dae")
        let idleScene = try! SCNScene(url: idleURL!, options: nil)
        
        for child in idleScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        
        characterNode = daeHolderNode.childNode(withName: "CATRigHub002", recursively: true)!
    }
    
    //MARK: animations
    private func loadAnimations() {
        loadAnimation(animationType: .walk, isSceneNamed: "art.scnassets/Scenes/Enemies/Golem@Flight", withIdentifier: "unnamed_animation__1")
        loadAnimation(animationType: .dead, isSceneNamed: "art.scnassets/Scenes/Enemies/Golem@Dead", withIdentifier: "Golem@Dead-1")
        loadAnimation(animationType: .attack1, isSceneNamed: "art.scnassets/Scenes/Enemies/Golem@Attack(1)", withIdentifier: "Golem@Attack(1)-1")
        
    }
    
    private func loadAnimation(animationType: EnemyAnimationType, isSceneNamed scene: String, withIdentifier identifier: String) {
        guard let sceneURL = Bundle.main.url(forResource: scene, withExtension: "dae") else { return }
        guard let sceneSource = SCNSceneSource(url: sceneURL, options: nil) else { return }
        
        guard let animationObject: CAAnimation = sceneSource.entryWithIdentifier(identifier, withClass: CAAnimation.self) else { return }
        
        animationObject.delegate = self
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
            
        case .attack1:
            animationObject.setValue("attack", forKey: "animationId")
            attack1Animation = animationObject
        }
    }
}

extension Enemy: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let id = anim.value(forKey: "animationId") as? String else { return }
        
        //TODO later
    }
}
