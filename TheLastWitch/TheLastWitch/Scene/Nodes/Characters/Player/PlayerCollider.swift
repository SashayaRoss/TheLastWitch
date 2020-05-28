//
//  PlayerCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PlayerCollider: ColliderInterface {
    var collider: SCNNode!
    
    func setupCollider(with scale: CGFloat) -> SCNNode {
        let geometry = SCNCapsule(capRadius: 1.2, height: 4)
        geometry.firstMaterial?.diffuse.contents = UIColor.red

        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0.0, 2.5, 0.0)
        collider.name = "collider"
        collider.opacity = 0.0

        let physicsGeometry = SCNCapsule(capRadius: 1.2 * scale, height: 4 * scale)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().player
        collider.physicsBody!.contactTestBitMask = Bitmask().wall

        return collider
    }
}
