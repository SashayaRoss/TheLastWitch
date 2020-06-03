//
//  EnemyCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class EnemyCollider: ColliderInterface {
    var collider: SCNNode!

    func setupCollider(with scale: CGFloat) -> SCNNode {
        let geometry = SCNCapsule(capRadius: 2, height: 6)
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0.0, 1.5, 0.0)
        collider.name = "enemyCollider"
        collider.opacity = 0.0
        
        let physicsGeometry = SCNCapsule(capRadius: 2 * scale, height: 6 * scale)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().enemy
        collider.physicsBody!.contactTestBitMask = Bitmask().wall | Bitmask().player | Bitmask().playerWeapon | Bitmask().npc | Bitmask().interactiveObject
        
        return collider
    }
}
