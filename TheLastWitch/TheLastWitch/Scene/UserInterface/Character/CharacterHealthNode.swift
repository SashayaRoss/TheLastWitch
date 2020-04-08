//
//  CharacterHealthNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 08/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterHealthNode {
    private var addButtonSprite: SKSpriteNode!
    private var healthLabel: SKLabelNode!
    private var healthPointsLabel: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
    
    func update(health: String) {
        healthPointsLabel.text = health
    }
    
    func button(isVisible: Bool) {
        if !isVisible {
            addButtonSprite.removeFromParent()
        }
    }
}

extension CharacterHealthNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        healthLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        healthLabel.name = "CharacterHealthNode"
        healthLabel.position = CGPoint(x: 75, y: bounds.size.height - 160)
        healthLabel.fontSize = 25
        healthLabel.horizontalAlignmentMode = .left
        healthLabel.verticalAlignmentMode = .top
        healthLabel.fontColor = .brownLetters
        healthLabel.text = "HEALTH"
        
        healthPointsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        healthPointsLabel.name = "CharacterHealthPointsNode"
        healthPointsLabel.position = CGPoint(x: 210, y: bounds.size.height - 160)
        healthPointsLabel.fontSize = 25
        healthPointsLabel.horizontalAlignmentMode = .left
        healthPointsLabel.verticalAlignmentMode = .top
        healthPointsLabel.fontColor = .brownLetters
        
        addButtonSprite = SKSpriteNode(imageNamed: directory + "addButtonChar.png")
        addButtonSprite.name = "CharacterAddHealthNode"
        addButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        addButtonSprite.position = CGPoint(x: 280, y: bounds.size.height - 190)
        addButtonSprite.size = CGSize(
            width: 40,
            height: 40
        )
       
        update(health: "100")
        scene.addChild(healthLabel)
        scene.addChild(healthPointsLabel)
        scene.addChild(addButtonSprite)
    }
}

extension CharacterHealthNode: VirtualBoundsSetupInterface {
    func virtualNodeBounds() -> CGRect {
        let virtualCharacterNameBounds = CGRect(x: 280.0, y: bounds.size.height - 230, width: 40, height: 40)
        
        return virtualCharacterNameBounds
    }
}
