//
//  VictoryNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 18/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class VictoryNode {
    private var bgNode: SKSpriteNode!
    private var victorySprite: SKSpriteNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension VictoryNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        victorySprite = SKSpriteNode(imageNamed: directory + "victory.png")
        victorySprite.name = "VictoryNode"
        victorySprite.size = CGSize(width: 500, height: 110)
        victorySprite.position = CGPoint(
            x: (bounds.size.width / 2) - (victorySprite.size.width / 2),
            y: (bounds.size.height / 2) - (victorySprite.size.height / 2)
        )
        victorySprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        scene.addChild(victorySprite)
    }
}
