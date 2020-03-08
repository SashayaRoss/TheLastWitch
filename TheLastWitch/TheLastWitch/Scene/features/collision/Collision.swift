//
//  Collision.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 01/02/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class Collision {
    let scene: SCNScene
    
    init(scene: SCNScene) {
        self.scene = scene
        setupWallBitmasks()
    }
    
    //MARK: walls collision
    private func setupWallBitmasks() {
        var collisionNodes = [SCNNode]()
        scene.rootNode.enumerateChildNodes { (node, _) in
            switch node.name {
            case let .some(s) where s.range(of: "collision") != nil:
                collisionNodes.append(node)
            default:
                break
            }
        }
        for node in collisionNodes {
            node.physicsBody = SCNPhysicsBody.static()
            node.physicsBody!.categoryBitMask = Bitmask().wall
            node.physicsBody!.physicsShape = SCNPhysicsShape(node: node, options: [.type: SCNPhysicsShape.ShapeType.concavePolyhedron as NSString])
        }
    }
    
}
