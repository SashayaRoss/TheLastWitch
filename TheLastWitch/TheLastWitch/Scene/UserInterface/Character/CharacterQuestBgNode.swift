//
//  CharacterQuestListNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 07/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterQuestBgNode {
    private var characterQuestListSprite: SKSpriteNode!
    private var questTitle: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension CharacterQuestBgNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        characterQuestListSprite = SKSpriteNode(imageNamed: directory + "charQuest.png")
        characterQuestListSprite.name = "characterQuestListSprite"
        characterQuestListSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        characterQuestListSprite.size = CGSize(width: 230, height: 260)
        characterQuestListSprite.position = CGPoint(
            x: bounds.size.width - 50 - characterQuestListSprite.size.width,
            y: bounds.size.height - 50 - characterQuestListSprite.size.height
        )
        
        questTitle = SKLabelNode(fontNamed: "AvenirNextCondensed-Medium")
        questTitle.name = "questTitleNode"
        questTitle.fontSize = 30
        questTitle.horizontalAlignmentMode = .left
        questTitle.verticalAlignmentMode = .top
        questTitle.fontColor = .brownLetters
        questTitle.preferredMaxLayoutWidth = bounds.size.width - 40
        questTitle.position = CGPoint(
            x: bounds.size.width - 30 - characterQuestListSprite.size.width,
            y: bounds.size.height - 70
        )
        
        questTitle.text = "Quests:"
        
       
        scene.addChild(characterQuestListSprite)
        scene.addChild(questTitle)
    }
}
