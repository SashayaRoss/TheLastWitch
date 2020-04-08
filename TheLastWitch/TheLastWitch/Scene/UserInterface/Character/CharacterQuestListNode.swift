//
//  CharacterQuestListNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 07/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterQuestListNode {
    private var questList: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
    
    func updateQuestList(quest: String? = "No new quests") {
        questList.text =  quest
    }
}

extension CharacterQuestListNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        questList = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        questList.name = "questTitleNode"
        questList.fontSize = 18
        questList.horizontalAlignmentMode = .left
        questList.verticalAlignmentMode = .top
        questList.fontColor = .brownLetters
        questList.numberOfLines = 2
        questList.preferredMaxLayoutWidth = 200
        questList.position = CGPoint(
            x: bounds.size.width - 260,
            y: bounds.size.height - 100
        )
        
        updateQuestList()
        scene.addChild(questList)
    }
}
