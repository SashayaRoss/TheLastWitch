//
//  OptionsDevModeNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class OptionsDevModeNode {
    private var devModeSprite: SKSpriteNode!
    private var devModeText: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension OptionsDevModeNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        devModeSprite = SKSpriteNode(imageNamed: directory + "optionsButton.png")
        devModeSprite.name = "OptionsDevNode"
        devModeSprite.size = CGSize(width: 240, height: 50)
        devModeSprite.position = CGPoint(
            x: (bounds.size.width / 2) - (devModeSprite.size.width / 2),
            y: bounds.size.height - 220
        )
        devModeSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
       
        devModeText = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        devModeText.name = "OptionsHeaderTextNode"
        devModeText.fontSize = 22
                devModeText.text = "DEV MODE OFF/ON"
        devModeText.position = CGPoint(
            x: (bounds.size.width / 2) - 75,
            y: bounds.size.height - 185
        )
        devModeText.horizontalAlignmentMode = .left
        devModeText.verticalAlignmentMode = .top
        devModeText.fontColor = .brownLetters
    
        scene.addChild(devModeSprite)
        scene.addChild(devModeText)
    }
}

extension OptionsDevModeNode: VirtualBoundsSetupInterface {
    func virtualNodeBounds() -> CGRect {
        let virtualBounds = CGRect(
            x: (bounds.size.width / 2) - (devModeSprite.size.width / 2),
            y: bounds.size.height - 220,
            width: 240,
            height: 50
        )
        
        return virtualBounds
    }
}
