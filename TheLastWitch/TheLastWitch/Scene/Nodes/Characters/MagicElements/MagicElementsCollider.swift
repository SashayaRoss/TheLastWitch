//
//  MagicElementsCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class MagicElementsCollider: ColliderInterface {
    var collider: SCNNode!

    func setupCollider(with scale: CGFloat) -> SCNNode {
        let geometry = SCNCapsule(capRadius: 60, height: 200)
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0.0, 120, 0.0)
        collider.name = "magicElementCollider"
        collider.opacity = 0.0
        
        let physicsGeometry = SCNCapsule(capRadius: 20 * scale, height: 52 * scale)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().magicElement
        collider.physicsBody!.contactTestBitMask = Bitmask().wall | Bitmask().player | Bitmask().playerWeapon | Bitmask().enemy | Bitmask().npc
        
        return collider
    }
}
