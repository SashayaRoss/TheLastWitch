//
//  DialogTextNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class DialogTextNode {
    private var dialogSprite: SKLabelNode!
    private var bounds: CGRect
    
    init(bounds: CGRect) {
        self.bounds = bounds
    }
    
    func update(dialog: String) {
        dialogSprite.text = dialog
    }
}

extension DialogTextNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        dialogSprite = SKLabelNode(fontNamed: "Menlo")
        dialogSprite.name = "DialogTextNode"
        dialogSprite.position = CGPoint(x: 30, y: 130)
        dialogSprite.fontSize = 14
        dialogSprite.horizontalAlignmentMode = .left
        dialogSprite.verticalAlignmentMode = .top
        dialogSprite.preferredMaxLayoutWidth = bounds.size.width - 40
        dialogSprite.numberOfLines = 2
        dialogSprite.fontColor = .brownLetters
    
        scene.addChild(dialogSprite)
    }
}
