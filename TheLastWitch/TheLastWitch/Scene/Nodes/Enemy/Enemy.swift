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
    private var collider: SCNNode!
    
    //animations
    private var walkAnimation = CAAnimation()
    private var deadAnimation = CAAnimation()
    private var attack1Animation = CAAnimation()
    
    //movement
    private var previousUpdateTime = TimeInterval(0.0)
    private let noticeDistance: Float = 3.0
    private let movementSpeedLimiter = Float(0.5)
    
    private var isWalking: Bool = false {
        didSet {
            if oldValue != isWalking {
                if isWalking {
                    addAnimation(walkAnimation, forKey: "walk")
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
        name = "Enemy"
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
    
    func update(with time: TimeInterval, and scene: SCNScene) {
        guard let enemy = enemy else { return }
        
        //delta time
        if previousUpdateTime == 0.0 { previousUpdateTime = time }
        let deltaTime = Float(min(time - previousUpdateTime, 1.0/60.0))
        previousUpdateTime = time
        
        // get distance
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
            
            if !isCollidingWithEnemy {
                let characterSpeed = deltaTime * movementSpeedLimiter
                
                if vx != 0.0 && vz != 0.0 {
                    position.x += vx * characterSpeed
                    position.z += vz * characterSpeed
                    
                    isWalking = true
                } else {
                    isWalking = false
                }
                
                //update the altitude
                let initialPosition = position
                var pos = position
                var endpoint0 = pos
                var endpoint1 = pos
                
                endpoint0.y -= 0.1
                endpoint1.y += 0.08
                
                let result = scene.physicsWorld.rayTestWithSegment(from: endpoint1, to: endpoint0, options: [.collisionBitMask: BitmaskWall, .searchMode: SCNPhysicsWorld.TestSearchMode.closest])
                
                if let result = result.first {
                    let groundAltitude = result.worldCoordinates.y
                    pos.y = groundAltitude
                    
                    position = pos
                } else {
                    position = initialPosition
                }
            } else {
                //TODO later
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
        collider.physicsBody!.categoryBitMask = BitMaskEnemy
        collider.physicsBody!.contactTestBitMask = BitmaskWall | BitmaskPlayer | BitmaskPlayerWeapon
        
        gameView.prepare([collider]) {
            (finished) in
            self.addChildNode(self.collider)
        }
    }
}

extension Enemy: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let id = anim.value(forKey: "animationId") as? String else { return }
        
        //TODO later
    }
}
