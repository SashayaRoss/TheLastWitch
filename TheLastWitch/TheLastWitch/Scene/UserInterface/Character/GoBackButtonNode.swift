//
//  GoBackButtonNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 07/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class GoBackButtonNode {
    private var goBackButtonSprite: SKSpriteNode!
    private var label: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension GoBackButtonNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        goBackButtonSprite = SKSpriteNode(imageNamed: directory + "goBackButton.png")
        goBackButtonSprite.name = "CharacterNode"
        goBackButtonSprite.position = CGPoint(x: 70, y: 20)
        goBackButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        goBackButtonSprite.size = CGSize(
            width: 170,
            height: 50
        )
        
        label = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        label.name = "CharacterNameTextNode"
        label.position = CGPoint(x: 125, y: 55)
        label.fontSize = 25
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .top
        label.fontColor = .brownLetters
        label.text = "CLOSE"
       
        scene.addChild(goBackButtonSprite)
        scene.addChild(label)
    }
}

extension GoBackButtonNode: VirtualBoundsSetupInterface {
    func virtualNodeBounds() -> CGRect {
        let virtualCharacterNameBounds = CGRect(x: 70.0, y: bounds.size.height - 80, width: 170, height: 50)
        
        return virtualCharacterNameBounds
    }
}
