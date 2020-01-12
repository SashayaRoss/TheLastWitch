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
    
    //animation
    private let animation: PlayerAnimation
    
    //movement
    private var previousUpdateTime = TimeInterval(0.0)
    private var isWalking: Bool = false
//    {
//        didSet {
//            if oldValue != isWalking {
//                characterNode.addAnimation(animation.walkAnimation, forKey: "walk")
//            } else {
//                characterNode.removeAnimation(forKey: "walk")
//            }
//        }
//    }
    
    private var directionAngle: Float = 0.0 {
        didSet {
            if directionAngle != oldValue {
                runAction(SCNAction.rotateTo(x: 0.0, y: CGFloat(directionAngle), z: 0.0, duration: 0.1, usesShortestUnitArc: true))
            }
        }
    }
    
    //collision
    var replacementPosition: SCNVector3 = SCNVector3Zero
    
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
    
    //MARK: scene
    func setupModel() {
        let playerURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Hero/idle", withExtension: "dae")
        let playerScene = try! SCNScene(url: playerURL!, options: nil)
        
        for child in playerScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        
        //set mesh name
        characterNode = daeHolderNode.childNode(withName: "Bip01", recursively: true)!
    }
    
    //MARK: movement
    func walkInDirection(_ direction: float3, time: TimeInterval, scene: SCNScene) {
        if previousUpdateTime == 0.0 {
            previousUpdateTime = time
        }
        let deltaTime = Float(min(time - previousUpdateTime, 1.0/60.0))
        let characterSpeed = deltaTime * 2
        previousUpdateTime = time
        
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
    }
    
    // MARK: collisions
    func setupCollider(with scale: CGFloat) {
        let geometry = SCNCapsule(capRadius: 47, height: 165)
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        
        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0.0, 140.0, 0.0)
        collider.name = "collider"
        collider.opacity = 1.0
        
        let phisicsGeometry = SCNCapsule(capRadius: 47 * scale, height: 165 * scale)
        let phisicsShape = SCNPhysicsShape(geometry: phisicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: phisicsShape)
        collider.physicsBody!.categoryBitMask = BitmaskPlayer
        collider.physicsBody!.contactTestBitMask = BitmaskWall
        
        addChildNode(collider)
    }
}

