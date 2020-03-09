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
    private let animation: PlayerAnimation
    
    //movement
    private var previousUdateTime = TimeInterval(0.0)
    
    private var isWalking:Bool = false {
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
    var replacementPosition:SCNVector3 = SCNVector3Zero
    private var activeWeaponCollideNodes = Set<SCNNode>()
    
    //battle
    var isDead = false
    private let maxHpPoints:Float = 100.0
    private var hpPoints:Float = 100.0
    var isAttacking = false
    private var attackTimer:Timer?
    private var attackFrameCounter = 0
    
    //MARK: initialization
    init(animation: PlayerAnimation) {
        self.animation = animation
        super.init()
        setupModel()
        animation.loadAnimations()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- scene
    private func setupModel() { 
        //load dae childs
        let playerURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Hero/idle", withExtension: "dae")
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
        
        let geometry = SCNCapsule(capRadius: 47, height: 165)
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        
        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0.0, 140.0, 0.0)
        collider.name = "collider"
        collider.opacity = 0.0
        
        let physicsGeometry = SCNCapsule(capRadius: 47 * scale, height: 165 * scale)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().player
        collider.physicsBody!.contactTestBitMask = Bitmask().wall
        
        addChildNode(collider)
    }
    
    func weaponCollide(with node:SCNNode) {
        activeWeaponCollideNodes.insert(node)
    }
    
    func weaponUnCollide(with node:SCNNode) {
        activeWeaponCollideNodes.remove(node)
    }
    
    //MARK:- battle
    func gotHit(with hpPoints:Float) {
        self.hpPoints -= hpPoints
        NotificationCenter.default.post(name: NSNotification.Name("hpChanged"), object: nil, userInfo: ["playerMaxHp": maxHpPoints, "currentHp": hpPoints])
        
        if self.hpPoints <= 0 {
            die()
        }
    }
    
    private func die() {
        isDead = true
        characterNode.removeAllActions()
        characterNode.removeAllAnimations()
        characterNode.addAnimation(animation.deadAnimation, forKey: "dead")
    }
    
    func attack() {
        if isAttacking || isDead { return }
        isAttacking = true
        isWalking = false
        
        attackTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(attackTimerTicked), userInfo: nil, repeats: true)
        
        characterNode.removeAllAnimations()
        characterNode.addAnimation(animation.attackAnimation, forKey: "attack")
    }
    
    @objc private func attackTimerTicked(timer: Timer) {
        attackFrameCounter += 1
        if attackFrameCounter == 12 {
            for node in activeWeaponCollideNodes {
                if let enemy = node as? Enemy {
                    enemy.gotHit(by: node, with: 30.0)
                }
            }
        }
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
}

//MARK:- extensions

extension Player: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let id = anim.value(forKey: "animationId") as? String else { return }
        if id == "attack" {
            attackTimer?.invalidate()
            attackFrameCounter = 0
            isAttacking = false
        }
    }
}
