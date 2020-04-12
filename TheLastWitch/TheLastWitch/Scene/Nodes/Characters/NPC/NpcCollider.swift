//
//  NpcCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class NpcCollider: ColliderInterface {
    var collider: SCNNode!

    func setupCollider(with scale: CGFloat) -> SCNNode {
        let geometry = SCNCapsule(capRadius: 30, height: 80)
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0.0, 46, 0.0)
        collider.name = "npcCollider"
        collider.opacity = 1.0
        
        let physicsGeometry = SCNCapsule(capRadius: 20 * scale, height: 52 * scale)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().npc
        collider.physicsBody!.contactTestBitMask = Bitmask().wall | Bitmask().player | Bitmask().playerWeapon | Bitmask().enemy | Bitmask().magicElement
        
        return collider
    }
}
