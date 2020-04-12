//
//  GameOverNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class GameOverNode {
    private var bgNode: SKSpriteNode!
    private var gameOverSprite: SKSpriteNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension GameOverNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        gameOverSprite = SKSpriteNode(imageNamed: directory + "gameOver.png")
        gameOverSprite.name = "GameOverNode"
        gameOverSprite.size = CGSize(width: 500, height: 130)
        gameOverSprite.position = CGPoint(
            x: (bounds.size.width / 2) - (gameOverSprite.size.width / 2),
            y: (bounds.size.height / 2) - (gameOverSprite.size.height / 2)
        )
        gameOverSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    
        bgNode = SKSpriteNode()
        bgNode.color = .black
        bgNode.name = "GameOverBgNode"
        bgNode.size = CGSize(width: bounds.size.width, height: bounds.size.height)
        bgNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
//        scene.addChild(bgNode)
        scene.addChild(gameOverSprite)
    }
}
