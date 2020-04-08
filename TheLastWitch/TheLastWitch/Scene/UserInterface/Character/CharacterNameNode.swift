//
//  CharacterNameNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 07/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterNameNode {
    private var characterNameSprite: SKSpriteNode!
    private var nameText: SKLabelNode!
    private var level: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
    
    func updateName(name: String? = "Anabelle") {
        nameText.text = name
    }
    
    func updateLevel(newLevel: String, points: String? = nil) {
        let levelString = "LV" + newLevel
        level.text = levelString
        if let pointsUpdate = points {
            let currentPoints = "(" + pointsUpdate + ")"
            level.text = levelString + " " + currentPoints
        }
    }
}

extension CharacterNameNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        characterNameSprite = SKSpriteNode(imageNamed: directory + "charNameField.png")
        characterNameSprite.name = "CharacterNameNode"
        characterNameSprite.size = CGSize(width: 280, height: 50)
        characterNameSprite.position = CGPoint(x: 60, y: bounds.size.height - 100)
        characterNameSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
       
        nameText = SKLabelNode(fontNamed: "Snell Roundhand")
        nameText.name = "CharacterNameTextNode"
        nameText.position = CGPoint(x: 70, y: bounds.size.height - 60)
        nameText.fontSize = 34
        nameText.horizontalAlignmentMode = .left
        nameText.verticalAlignmentMode = .top
        nameText.fontColor = .brownLetters
    
        level = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        level.name = "CharacterNameTextNode"
        level.fontSize = 28
        level.horizontalAlignmentMode = .left
        level.verticalAlignmentMode = .top
        level.fontColor = .brownLetters
        level.position = CGPoint(
            x: 70 + 180,
            y: bounds.size.height - 63
        )
        
        updateName()
        updateLevel(newLevel: "1")
        
        scene.addChild(characterNameSprite)
        scene.addChild(nameText)
        scene.addChild(level)
    }
}
