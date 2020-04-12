//
//  OptionsMusicNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class OptionsMusicNode {
    private var musicSprite: SKSpriteNode!
    private var musicText: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension OptionsMusicNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        musicSprite = SKSpriteNode(imageNamed: directory + "optionsButton.png")
        musicSprite.name = "OptionsHeaderNode"
        musicSprite.size = CGSize(width: 240, height: 50)
        musicSprite.position = CGPoint(
            x: (bounds.size.width / 2) - (musicSprite.size.width / 2),
            y: bounds.size.height - 290
        )
        musicSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
       
        musicText = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        musicText.name = "OptionsMusicNode"
        musicText.fontSize = 22
                musicText.text = "MUSIC OFF/ON"
        musicText.position = CGPoint(
            x: (bounds.size.width / 2) - 55,
            y: bounds.size.height - 255
        )
        musicText.horizontalAlignmentMode = .left
        musicText.verticalAlignmentMode = .top
        musicText.fontColor = .brownLetters
    
        scene.addChild(musicSprite)
        scene.addChild(musicText)
    }
}

extension OptionsMusicNode: VirtualBoundsSetupInterface {
    func virtualNodeBounds() -> CGRect {
        let virtualBounds = CGRect(
            x: (bounds.size.width / 2) - (musicSprite.size.width / 2),
            y: bounds.size.height - 150,
            width: 240,
            height: 50
        )
        
        return virtualBounds
    }
}
