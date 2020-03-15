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
    private var collider: SCNNode!
    
    //animation
    private var animation: AnimationInterface!
    
    //movement
    private var previousUpdateTime = TimeInterval(0.0)
    private let noticeDistance: Float = 3.0
    private let movementSpeedLimiter = Float(0.5)
    
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
    
    //attack
    private var isAttacking = false
    private var lastAttackTime: TimeInterval = 0.0
    private var attackTimer: Timer?
    private var attackFrameCounter = 0
    
    private var hpPoints:Float = 70.0
    private var isDead = false
    
    //MARK: init
    init(enemy: Player, view: GameView) {
        super.init()
        
        self.gameView = view
        self.player = enemy
        
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
        let idleURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Enemies/Golem@Idle", withExtension: "dae")
        let idleScene = try! SCNScene(url: idleURL!, options: nil)
        
        for child in idleScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        characterNode = daeHolderNode.childNode(withName: "CATRigHub002", recursively: true)!
    }
    
    
    func update(with time: TimeInterval, and scene: SCNScene) {
        guard let enemy = player, !enemy.isDead, !isDead else { return }
        
         //delta time
         if previousUpdateTime == 0.0 { previousUpdateTime = time }
         let deltaTime = Float(min (time - previousUpdateTime, 1.0 / 60.0))
         previousUpdateTime = time
         
         //get distance
         let distance = GameUtils.distanceBetweenVectors(vector1: enemy.position, vector2: position)
        
         if distance < noticeDistance && distance > 0.01 {
             
             //move
            let vResult = GameUtils.getCoordinatesNeededToMoveToReachNode(from: position, to: enemy.position)
             let vx = vResult.vX
             let vz = vResult.vZ
             let angle = vResult.angle
             
             //rotate
             let fixedAngle = GameUtils.getFixedRotationAngle(with: angle)
             eulerAngles = SCNVector3Make(0, fixedAngle, 0)
             
             if !isCollidingWithEnemy && !isAttacking {
             
                 let characterSpeed = deltaTime * movementSpeedLimiter
                 
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
                 if lastAttackTime == 0.0 {
                     
                     lastAttackTime = time
                     attack()
                 }
                 let timeDiff = time - lastAttackTime
                 if timeDiff >= 2.5 {
                     lastAttackTime = time
                     attack()
                 }
             }
         } else {
             isWalking = false
         }
    }
    
    //MARK: collision
    func setupCollider(scale: CGFloat) {
        let geometry = SCNCapsule(capRadius: 20, height: 52)
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        collider = SCNNode(geometry: geometry)
        collider.name = "enemyCollider"
        collider.position = SCNVector3Make(0, 46, 0)
        collider.opacity = 0.0
        
        let shapeGeometry = SCNCapsule(capRadius: 20 * scale, height: 52 * scale)
        let physicsShape = SCNPhysicsShape(geometry: shapeGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().enemy
        collider.physicsBody!.contactTestBitMask = Bitmask().wall | Bitmask().player | Bitmask().playerWeapon
        
        gameView.prepare([collider]) { (finished) in
            self.addChildNode(self.collider)
        }
    }
    
    @objc func attackTimerTicked() {
        attackFrameCounter += 1
        if attackFrameCounter == 10 {
            if isCollidingWithEnemy {
                player.gotHit(with: 5)
            }
        }
    }
    
    func gotHit(by node:SCNNode, with hpHitPoints:Float) {
        hpPoints -= hpHitPoints
        if hpPoints <= 0 {
            die()
            //drop loot
            //add exp to player
        }
    }
}

extension Enemy: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        attackTimer?.invalidate()
        attackFrameCounter = 0
        isAttacking = false
        
        guard let id = anim.value(forKey: "animationId") as? String else { return }
        if id == "attack" {
            attackTimer?.invalidate()
            attackFrameCounter = 0
            isAttacking = false
        }
    }
}

//MARK: battle
extension Enemy: BattleAction {    
    func attack() {
        if isAttacking { return }
        isAttacking = true
        DispatchQueue.main.async {
            self.attackTimer?.invalidate()
            self.attackTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.attackTimerTicked), userInfo: nil, repeats: true)
            self.characterNode.addAnimation(self.animation.attackAnimation, forKey: "attack")
        }
    }
    
    func die() {
        isDead = true
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
