//
//  WelcomeScreenTapNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class WelcomeScreenTapNode {
    private var tapSprite: SKSpriteNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension WelcomeScreenTapNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        tapSprite = SKSpriteNode(imageNamed: directory + "tapToPlay.png")
        tapSprite.name = "TapWelcomeScreenNode"
        tapSprite.size = CGSize(width: 200, height: 100)
        tapSprite.position = CGPoint(
            x: (bounds.size.width / 2) - (tapSprite.size.width / 2),
            y: 10
        )
        tapSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        sleep(3)
        scene.addChild(tapSprite)
    }
}
