//
//  CharacterMagicNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 08/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterMagicNode {
    private var addButtonSprite: SKSpriteNode!
    private var magicLabel: SKLabelNode!
    private var magicPointsLabel: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
    
    func update(magic: String) {
        magicPointsLabel.text = magic
    }
    
    func button(isVisible: Bool) {
        if !isVisible {
            addButtonSprite.removeFromParent()
        }
    }
}

extension CharacterMagicNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        magicLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        magicLabel.name = "CharacterMagicNode"
        magicLabel.position = CGPoint(x: 75, y: bounds.size.height - 210)
        magicLabel.fontSize = 25
        magicLabel.horizontalAlignmentMode = .left
        magicLabel.verticalAlignmentMode = .top
        magicLabel.fontColor = .brownLetters
        magicLabel.text = "MAGIC"
        
        magicPointsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        magicPointsLabel.name = "CharacterMagicPointsNode"
        magicPointsLabel.position = CGPoint(x: 210, y: bounds.size.height - 210)
        magicPointsLabel.fontSize = 25
        magicPointsLabel.horizontalAlignmentMode = .left
        magicPointsLabel.verticalAlignmentMode = .top
        magicPointsLabel.fontColor = .brownLetters
        
        addButtonSprite = SKSpriteNode(imageNamed: directory + "addButtonChar.png")
        addButtonSprite.name = "CharacterAddMagicNode"
        addButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        addButtonSprite.position = CGPoint(x: 280, y: bounds.size.height - 240)
        addButtonSprite.size = CGSize(
            width: 40,
            height: 40
        )
        
        scene.addChild(magicLabel)
        scene.addChild(magicPointsLabel)
        scene.addChild(addButtonSprite)
    }
}

extension CharacterMagicNode: VirtualBoundsSetupInterface {
    func virtualNodeBounds() -> CGRect {
        let virtualBounds = CGRect(
            x: 280.0,
            y: bounds.size.height - 180,
            width: 40,
            height: 40
        )
        
        return virtualBounds
    }
}
