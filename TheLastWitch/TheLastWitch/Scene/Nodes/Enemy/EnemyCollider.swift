//
//  EnemyCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

final class EnemyCollider {
    private var collider: SCNNode
    private let gameView: GameView
    
    init(collider: SCNNode, gameView: GameView) {
        self.collider = collider
        self.gameView = gameView
    }
    
    func setupCollider(scale: CGFloat) -> SCNNode {
        let geometry = SCNCapsule(capRadius: 20, height: 52)
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        collider = SCNNode(geometry: geometry)
        collider.name = "enemyCollider"
        collider.position = SCNVector3Make(0, 46, 0)
        collider.opacity = 0.0
        
        let shapeGeometry = SCNCapsule(capRadius: 20 * scale, height: 52 * scale)
        let physicsShape = SCNPhysicsShape(geometry: shapeGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = Bitmask().enemy
        collider.physicsBody!.contactTestBitMask = Bitmask().wall | Bitmask().player | Bitmask().playerWeapon
        
        return collider
//        gameView.prepare([collider]) { (finished) in
//            self.addChildNode(self.collider)
//        }
    }
}
