//
//  Enemy.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/01/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

final class Enemy: SCNNode {
    //general
    var gameView: GameView!
    
    //nodes
    private let daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var player: Player!
    
    //animation
    private var animation: AnimationInterface!
    
    //movement
    private var previousUpdateTime = TimeInterval(0.0)
    
    private var isWalking: Bool = false {
        didSet {
            if oldValue != isWalking {
                if isWalking {
                    addAnimation(animation.walkAnimation, forKey: "walk")
                } else {
                    removeAnimation(forKey: "walk")
                }
            }
        }
    }
    
    var isCollidingWithEnemy = false {
        didSet {
            if oldValue != isCollidingWithEnemy {
                if isCollidingWithEnemy {
                    isWalking = false
                }
            }
        }
    }
    
    //model
    var enemyModel: EnemyModel!

    private var attackTimer: Timer?
    private var attackFrameCounter = 0
    
    //MARK: init
    init(player: Player, view: GameView, enemyModel: EnemyModel) {
        super.init()
        
        self.gameView = view
        self.player = player
        self.enemyModel = enemyModel
        
        setupModelScene()
        animation = EnemyAnimation()
        animation.loadAnimations()
        animation.object.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: scene
    private func setupModelScene() {
        name = "Enemy"
        let idleURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Characters/Enemies/Golem@Idle", withExtension: "dae")
        let idleScene = try! SCNScene(url: idleURL!, options: nil)
        
        for child in idleScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        characterNode = daeHolderNode.childNode(withName: "CATRigHub002", recursively: true)!
    }
    
    
    func update(with time: TimeInterval, and scene: SCNScene) {
        guard let player = player, !player.playerModel.isDead, !enemyModel.isDead else { return }
        
         //delta time
         if previousUpdateTime == 0.0 { previousUpdateTime = time }
         let deltaTime = Float(min (time - previousUpdateTime, 1.0 / 60.0))
         previousUpdateTime = time
         
         //get distance
         let distance = GameUtils.distanceBetweenVectors(vector1: player.position, vector2: position)
        
         if distance < enemyModel.noticeDistance && distance > 0.01 {
             
             //move
            let vResult = GameUtils.getCoordinatesNeededToMoveToReachNode(from: position, to: player.position)
             let vx = vResult.vX
             let vz = vResult.vZ
             let angle = vResult.angle
             
             //rotate
             let fixedAngle = GameUtils.getFixedRotationAngle(with: angle)
             eulerAngles = SCNVector3Make(0, fixedAngle, 0)
             
             if !isCollidingWithEnemy && !enemyModel.isAttacking {
             
                 let characterSpeed = deltaTime * enemyModel.movementSpeedLimiter
                 
                 if vx != 0.0 && vz != 0.0 {
                     
                     position.x += vx * characterSpeed
                     position.z += vz * characterSpeed
                     
                     isWalking = true
                 } else {
                     isWalking = false
                 }
                 
                 //update the altidute
                 let initialPosition = position
                 
                 var pos = position
                 var endpoint0 = pos
                 var endpoint1 = pos
                 
                 endpoint0.y -= 0.1
                 endpoint1.y += 0.08
                 
                let results = scene.physicsWorld.rayTestWithSegment(from: endpoint1, to: endpoint0, options: [.collisionBitMask: Bitmask().wall, .searchMode: SCNPhysicsWorld.TestSearchMode.closest])
                 
                 if let result = results.first {
                     
                     let groundAltitude = result.worldCoordinates.y
                     pos.y = groundAltitude
                     
                     position = pos
                 } else {
                     position = initialPosition
                 }
             } else {
                 //attack
                 if enemyModel.lastAttackTime == 0.0 {
                     
                     enemyModel.lastAttackTime = time
                     attack()
                 }
                 let timeDiff = time - enemyModel.lastAttackTime
                 if timeDiff >= 2.5 {
                     enemyModel.lastAttackTime = time
                     attack()
                 }
             }
         } else {
             isWalking = false
         }
    }
    
    //MARK: collision
    func setupCollider(scale: CGFloat) {
        let collider = EnemyCollider().setupCollider(with: scale)
        
        gameView.prepare([collider]) { (finished) in
            self.addChildNode(collider)
        }
    }
    
    @objc func attackTimerTicked() {
        attackFrameCounter += 1
        if attackFrameCounter == 10 {
            if isCollidingWithEnemy {
                player.gotHit(with: 20)
            }
        }
    }
    
    func gotHit(by node:SCNNode, with hpHitPoints:Float) {
        enemyModel.hpPoints -= hpHitPoints
        if enemyModel.hpPoints <= 0 && !enemyModel.isDead {
            let stats = player.playerModel
            die()
            stats.expPoints += 50
            NotificationCenter.default.post(name: NSNotification.Name("expChanged"), object: nil, userInfo: ["playerMaxExp": stats.maxExpPoints, "currentExp": stats.expPoints])
            if stats.expPoints >= stats.maxExpPoints {
                stats.level += 1
            }
            //drop loot
        }
    }
}

extension Enemy: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        attackTimer?.invalidate()
        attackFrameCounter = 0
        enemyModel.isAttacking = false
        
        guard let id = anim.value(forKey: "animationId") as? String else { return }
        if id == "attack" {
            attackTimer?.invalidate()
            attackFrameCounter = 0
            enemyModel.isAttacking = false
        }
    }
}

//MARK: battle
extension Enemy: BattleAction {    
    func attack() {
        if enemyModel.isAttacking { return }
        enemyModel.isAttacking = true
        DispatchQueue.main.async {
            self.attackTimer?.invalidate()
            self.attackTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.attackTimerTicked), userInfo: nil, repeats: true)
            self.characterNode.addAnimation(self.animation.attackAnimation, forKey: "attack")
        }
    }
    
    func die() {
        enemyModel.isDead = true
        addAnimation(animation.deadAnimation, forKey: "dead")
        
        let wait = SCNAction.wait(duration: 3.0)
        let remove = SCNAction.run { (node) in
            self.removeAllAnimations()
            self.removeAllActions()
            self.removeFromParentNode()
        }
        
        let seq = SCNAction.sequence([wait, remove])
        runAction(seq)
    }
}
