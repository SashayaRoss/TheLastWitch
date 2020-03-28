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
//    private var animation: AnimationInterface!
    private var walkAnimation = CAAnimation()
    private var attackAnimation = CAAnimation()
    private var deadAnimation = CAAnimation()

    //movement
    private var previousUdateTime = TimeInterval(0.0)
    private var isWalking: Bool = false {
        didSet {
            if oldValue != isWalking {
                if isWalking {
                    characterNode.addAnimation(walkAnimation, forKey: "walk")
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

    //battle
    var isDead = false
    private let maxHpPoints: Float = 100.0
    private var hpPoints: Float = 100.0
    var isAttacking = false
    private var attackTimer: Timer?
    private var attackFrameCounter = 0

    //MARK: initialization
    override init() {
        super.init()
        
        setupModel()
//        animation = PlayerAnimation()
//        animation.loadAnimations()
//        animation.object.delegate = self
        
        loadAnimations()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadAnimations() {
        loadAnimation(animationType: .walk, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/walk", withIdentifier: "WalkID")
        loadAnimation(animationType: .attack, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/attack", withIdentifier: "attackID")
        loadAnimation(animationType: .dead, isSceneNamed: "art.scnassets/Scenes/Characters/Hero/die", withIdentifier: "DeathID")
    }

    private func loadAnimation(animationType: PlayerAnimationType, isSceneNamed scene: String, withIdentifier identifier: String) {

        let sceneURL = Bundle.main.url(forResource: scene, withExtension: "dae")!
        let sceneSource = SCNSceneSource(url: sceneURL, options: nil)!
        
        let animationObject:CAAnimation = sceneSource.entryWithIdentifier(identifier, withClass: CAAnimation.self)!
        
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
        case .attack:
            animationObject.setValue("attack", forKey: "animationId")
            attackAnimation = animationObject
        }
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
        if isDead || isAttacking { return }
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
        collider = PlayerCollider().setupCollider(with: scale)
        addChildNode(collider)
    }

    func weaponCollide(with node:SCNNode) {
        print("Collides: \(node)")
        activeWeaponCollideNodes.insert(node)
    }

    func weaponUnCollide(with node:SCNNode) {
        print("Uncollides: \(node)")
        activeWeaponCollideNodes.remove(node)
    }

    //MARK:- weapon
    func setupWeaponCollider(with scale:CGFloat) {

        let geometryBox = SCNBox(width: 160.0, height: 140.0, length: 160.0, chamferRadius: 0.0)
        geometryBox.firstMaterial?.diffuse.contents = UIColor.orange
        weaponCollider = SCNNode(geometry: geometryBox)
        weaponCollider.name = "weaponCollider"
        weaponCollider.position = SCNVector3Make(-10, 108.4, 88)
        weaponCollider.opacity = 0.0
        addChildNode(weaponCollider)

        let geometry = SCNBox(width: 160.0 * scale, height: 140.0 * scale, length: 160.0 * scale, chamferRadius: 0.0)
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
        weaponCollider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        weaponCollider.physicsBody!.categoryBitMask = Bitmask().playerWeapon
        weaponCollider.physicsBody!.contactTestBitMask = Bitmask().enemy
    }
    
    func gotHit(with hpPoints: Float) {
        self.hpPoints -= hpPoints
        NotificationCenter.default.post(name: NSNotification.Name("hpChanged"), object: nil, userInfo: ["playerMaxHp": maxHpPoints, "currentHp": self.hpPoints])

        if self.hpPoints <= 0 {
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
            isAttacking = false
        }
    }
}

extension Player: BattleAction {
    func die() {
        isDead = true
        characterNode.removeAllActions()
        characterNode.removeAllAnimations()
        characterNode.addAnimation(deadAnimation, forKey: "dead")
        print("GAME OVER")
    }

    func attack() {
        if isAttacking || isDead { return }
        isAttacking = true
        isWalking = false

        attackTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(attackTimerTicked), userInfo: nil, repeats: true)

        characterNode.removeAllAnimations()
        characterNode.addAnimation(attackAnimation, forKey: "attack")
    }
}
