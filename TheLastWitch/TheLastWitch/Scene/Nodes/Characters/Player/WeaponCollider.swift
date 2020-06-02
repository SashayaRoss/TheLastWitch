//
//  WeaponCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class WeaponCollider: ColliderInterface {
    var collider: SCNNode!
    
    func setupCollider(with scale: CGFloat) -> SCNNode {
        let geometryBox = SCNBox(width: 3.0, height: 4.0, length: 4.0, chamferRadius: 0.0)
        geometryBox.firstMaterial?.diffuse.contents = UIColor.blue
        collider = SCNNode(geometry: geometryBox)
        collider.name = "weaponCollider"
        collider.position = SCNVector3Make(0, 2, 1)
        collider.opacity = 0.0

        let geometry = SCNBox(width: 2.0 * scale, height: 2.0 * scale, length: 2.0 * scale, chamferRadius: 0.0)
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().playerWeapon
        collider.physicsBody!.contactTestBitMask = Bitmask().enemy
        
        return collider
    }
}
