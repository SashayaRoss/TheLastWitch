//
//  OptionsNewGameNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class OptionsNewGameNode {
    private var newGameSprite: SKSpriteNode!
    private var newGameText: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension OptionsNewGameNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        newGameSprite = SKSpriteNode(imageNamed: directory + "optionsButton.png")
        newGameSprite.name = "OptionsHeaderNode"
        newGameSprite.size = CGSize(width: 240, height: 50)
        newGameSprite.position = CGPoint(
            x: (bounds.size.width / 2) - (newGameSprite.size.width / 2),
            y: bounds.size.height - 150
        )
        newGameSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
       
        newGameText = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        newGameText.name = "OptionsNewGameNode"
        newGameText.fontSize = 22
                newGameText.text = "NEW GAME"
        newGameText.position = CGPoint(
            x: (bounds.size.width / 2) - 45,
            y: bounds.size.height - 115
        )
        newGameText.horizontalAlignmentMode = .left
        newGameText.verticalAlignmentMode = .top
        newGameText.fontColor = .brownLetters
    
        scene.addChild(newGameSprite)
        scene.addChild(newGameText)
    }
}

extension OptionsNewGameNode: VirtualBoundsSetupInterface {
    func virtualNodeBounds() -> CGRect {
        let virtualBounds = CGRect(
            x: (bounds.size.width / 2) - (newGameSprite.size.width / 2),
            y: bounds.size.height - 290,
            width: 240,
            height: 50
        )

        return virtualBounds
    }
}
