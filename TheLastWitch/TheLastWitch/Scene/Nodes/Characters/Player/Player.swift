//
//  Player.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

final class Player: SCNNode {
    //nodes
    private var daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var collider: SCNNode!
    private var weaponCollider: SCNNode!

    //animation
    private var animation: AnimationInterface!

    //movement
    private var previousUdateTime = TimeInterval(0.0)
    private var isWalking: Bool = false {
        didSet {
            if oldValue != isWalking {
                if isWalking {
                    characterNode.addAnimation(animation.walkAnimation, forKey: "walk")
                } else {
                    characterNode.removeAnimation(forKey: "walk", blendOutDuration: 0.2)
                }
            }
        }
    }

    private var directionAngle:Float = 0.0 {
        didSet {
            if directionAngle != oldValue {
                runAction(SCNAction.rotateTo(x: 0.0, y: CGFloat(directionAngle), z: 0.0, duration: 0.1, usesShortestUnitArc: true))
            }
        }
    }

    //collisions
    var replacementPosition: SCNVector3 = SCNVector3Zero
    private var activeWeaponCollideNodes = Set<SCNNode>()
    private var activePlayerCollideNodes = Set<SCNNode>()
    
    //model
    let playerModel: PlayerModel
    
    private var attackTimer: Timer?
    private var attackFrameCounter = 0

    //MARK: initialization
    init(playerModel: PlayerModel) {
        self.playerModel = playerModel
        super.init()
        
        setupModel()
        animation = PlayerAnimation()
        animation.loadAnimations()
        animation.object.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- scene
    private func setupModel() {
        //load dae childs
        let playerURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Characters/Hero/idle", withExtension: "dae")
        let playerScene = try! SCNScene(url: playerURL!, options: nil)

        for child in playerScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)

        //set mesh name
        characterNode = daeHolderNode.childNode(withName: "Bip01", recursively: true)!
    }

    //MARK:- movement
    func walkInDirection(_ direction:float3, time:TimeInterval, scene:SCNScene) {
        if playerModel.isDead || playerModel.isAttacking || playerModel.isInteracting { return }
        if previousUdateTime == 0.0 {
            previousUdateTime = time
        }
        let deltaTime = Float(min (time - previousUdateTime, 1.0 / 60.0))
        let characterSpeed = deltaTime * 1.3
        previousUdateTime = time

        let initialPosition = position

        //move
        if direction.x != 0.0 && direction.z != 0.0 {
            //move character
            let pos = float3(position)
            position = SCNVector3(pos + direction * characterSpeed)

            //update angle
            directionAngle = SCNFloat(atan2f(direction.x, direction.z))

            isWalking = true
        } else {
            isWalking = false
        }

        //update altitude
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
    }

    //MARK:- collisions
    func setupCollider(with scale:CGFloat) {
        //player
        collider = PlayerCollider().setupCollider(with: scale)
        addChildNode(collider)
        
        //weapon
        weaponCollider = WeaponCollider().setupCollider(with: scale)
        addChildNode(weaponCollider)
    }

    func weaponCollide(with node:SCNNode) {
        activeWeaponCollideNodes.insert(node)
    }

    func weaponUnCollide(with node:SCNNode) {
        activeWeaponCollideNodes.remove(node)
    }
    
    func playerCollide(with node:SCNNode) {
        activePlayerCollideNodes.insert(node)
    }

    func playerUnCollide(with node:SCNNode) {
        activePlayerCollideNodes.remove(node)
    }
    
    func gotHit(with hpPoints: Float) {
        playerModel.hpPoints -= hpPoints
        NotificationCenter.default.post(name: NSNotification.Name("hpChanged"), object: nil, userInfo: ["playerMaxHp": playerModel.maxHpPoints, "currentHp": playerModel.hpPoints])

        if playerModel.hpPoints <= 0 {
            die()
        }
    }
    
    @objc func attackTimerTicked(timer: Timer) {
        attackFrameCounter += 1
        if attackFrameCounter == 12 {
            for node in activeWeaponCollideNodes {
                if let enemy = node as? Enemy {
                    enemy.gotHit(by: node, with: 30.0)
                }
            }
        }
    }
    
    func interact() {
        if playerModel.isAttacking || playerModel.isDead || playerModel.isInteracting { return }
        playerModel.isInteracting = true
        isWalking = false
        //
        for node in activeWeaponCollideNodes {
            if let npc = node as? Npc {
                npc.dialog()
            }
        }
        playerModel.isInteracting = false
        isWalking = true
    }
}

//MARK:- extensions
extension Player: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard
            let id = anim.value(forKey: "animationId") as? String
        else {
            return
        }
        if id == "attack" {
            attackTimer?.invalidate()
            attackFrameCounter = 0
            playerModel.isAttacking = false
        }
        
    }
}

extension Player: BattleAction {
    func attack() {
        if playerModel.isAttacking || playerModel.isDead || playerModel.isInteracting { return }
        playerModel.isAttacking = true
        isWalking = false

        DispatchQueue.main.async {
            self.attackTimer?.invalidate()
            self.attackTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.attackTimerTicked), userInfo: nil, repeats: true)
            self.characterNode.addAnimation(self.animation.attackAnimation, forKey: "attack")
        }
    }
    
    func die() {
        playerModel.isDead = true
        characterNode.removeAllActions()
        characterNode.removeAllAnimations()
        characterNode.addAnimation(animation.deadAnimation, forKey: "dead")
        print("GAME OVER")
    }
}
