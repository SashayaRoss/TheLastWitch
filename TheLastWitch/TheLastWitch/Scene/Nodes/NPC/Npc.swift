//
//  Npc.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

final class Npc: SCNNode {
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
    private let noticeDistance: Float = 1.0
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
    
    var isCollidingWithPlayer = false {
        didSet {
            if oldValue != isCollidingWithPlayer {
                if isCollidingWithPlayer {
                    isWalking = false
                }
            }
        }
    }
    
    //interaction
    private var isInteracting = false
    
    //MARK: init
    init(player: Player, view: GameView) {
        super.init()
        
        self.gameView = view
        self.player = player
        
        setupModelScene()
        animation = NpcAnimation()
        animation.loadAnimations()
        animation.object.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: scene
    private func setupModelScene() {
        name = "Npc"
        let idleURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Hero/idle", withExtension: "dae")
        let idleScene = try! SCNScene(url: idleURL!, options: nil)
        
        for child in idleScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        //set mesh name
        characterNode = daeHolderNode.childNode(withName: "Bip01", recursively: true)!
    }
    
    
    func update(with time: TimeInterval, and scene: SCNScene) {
        guard
            let player = player
        else {
            return
        }

        //delta time
        if previousUpdateTime == 0.0 { previousUpdateTime = time }
        let deltaTime = Float(min (time - previousUpdateTime, 1.0 / 60.0))
        previousUpdateTime = time

        //get distance
        let distance = GameUtils.distanceBetweenVectors(vector1: player.position, vector2: position)

        if distance < noticeDistance && distance > 0.01 {
            //interaction!
            
             //move
            let vResult = GameUtils.getCoordinatesNeededToMoveToReachNode(from: position, to: player.position)
             let vx = vResult.vX
             let vz = vResult.vZ
             let angle = vResult.angle
             
             //rotate
             let fixedAngle = GameUtils.getFixedRotationAngle(with: angle)
             eulerAngles = SCNVector3Make(0, fixedAngle, 0)
             
             isWalking = false
        }
    }
    
    //MARK: collision
    func setupCollider(scale: CGFloat) {
        let geometry = SCNCapsule(capRadius: 20, height: 52)
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        collider = SCNNode(geometry: geometry)
        collider.name = "npcCollider"
        collider.position = SCNVector3Make(0, 46, 0)
        collider.opacity = 0.0
        
        let shapeGeometry = SCNCapsule(capRadius: 20 * scale, height: 52 * scale)
        let physicsShape = SCNPhysicsShape(geometry: shapeGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().npc
        collider.physicsBody!.contactTestBitMask = Bitmask().wall | Bitmask().player | Bitmask().playerWeapon
        
        gameView.prepare([collider]) { (finished) in
            self.addChildNode(self.collider)
        }
    }
}

extension Npc: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let id = anim.value(forKey: "animationId") as? String else { return }
        if id == "interaction" {
            //interaction
        }
    }
}

