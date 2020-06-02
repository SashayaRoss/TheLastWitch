//
//  interactiveObjectsCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class InteractiveObjectCollider: ColliderInterface {
    var collider: SCNNode!

    func setupCollider(with scale: CGFloat) -> SCNNode {
        let geometry = SCNBox(width: 3.0, height: 2.0, length: 2.0, chamferRadius: 0.0)
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0, 0.3, 0)
        collider.name = "interactiveObjectCollider"
        collider.opacity = 0.0
        
        let physicsGeometry = SCNBox(width: 3.0 * scale, height: 2.0 * scale, length: 2.0 * scale, chamferRadius: 0.0)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().interactiveObject
        collider.physicsBody!.contactTestBitMask = Bitmask().wall | Bitmask().player | Bitmask().playerWeapon | Bitmask().enemy | Bitmask().npc
        
        return collider
    }
}
