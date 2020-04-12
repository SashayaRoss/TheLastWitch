//
//  OptionsHeaderNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class OptionsHeaderNode {
    private var headerSprite: SKSpriteNode!
    private var headerText: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension OptionsHeaderNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        headerSprite = SKSpriteNode(imageNamed: directory + "header.png")
        headerSprite.name = "OptionsHeaderNode"
        headerSprite.size = CGSize(width: 340, height: 65)
        headerSprite.position = CGPoint(
            x: (bounds.size.width / 2) - (headerSprite.size.width / 2),
            y: bounds.size.height - 80
        )
        headerSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
       
        headerText = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        headerText.name = "OptionsHeaderTextNode"
        headerText.fontSize = 34
                headerText.text = "OPTIONS"
        headerText.position = CGPoint(
            x: (bounds.size.width / 2) - 50,
            y: bounds.size.height - 35
        )
        headerText.horizontalAlignmentMode = .left
        headerText.verticalAlignmentMode = .top
        headerText.fontColor = .brownLetters
    
        scene.addChild(headerSprite)
        scene.addChild(headerText)
    }
}
