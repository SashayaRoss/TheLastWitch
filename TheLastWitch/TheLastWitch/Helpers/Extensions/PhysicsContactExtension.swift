//
//  PhysicsContactExtension.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

extension SCNPhysicsContact {
    func match(_ cathegory: Int, block: (_ matching: SCNNode, _ other: SCNNode) -> Void) {
        if self.nodeA.physicsBody!.categoryBitMask == cathegory {
            block(self.nodeA, self.nodeB)
        }
        if self.nodeB.physicsBody!.categoryBitMask == cathegory {
            block(self.nodeB, self.nodeA)
        }
    }
}
