//
//  PlayerCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PlayerCollider {
    private var collider: SCNNode!
    
    func setupCollider(with scale: CGFloat) -> SCNNode {
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

        return collider
    }
}
