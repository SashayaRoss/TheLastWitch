//
//  CharacterSpeedNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 08/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterSpeedNode {
    private var addButtonSprite: SKSpriteNode!
    private var speedLabel: SKLabelNode!
    private var speedPointsLabel: SKLabelNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
    
    func update(speed: String) {
        speedPointsLabel.text = speed
    }
    
    func button(isVisible: Bool) {
        if !isVisible {
            addButtonSprite.removeFromParent()
        }
    }
}

extension CharacterSpeedNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        speedLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        speedLabel.name = "CharacterSpeedNode"
        speedLabel.position = CGPoint(x: 75, y: bounds.size.height - 260)
        speedLabel.fontSize = 25
        speedLabel.horizontalAlignmentMode = .left
        speedLabel.verticalAlignmentMode = .top
        speedLabel.fontColor = .brownLetters
        speedLabel.text = "SPEED"
        
        speedPointsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        speedPointsLabel.name = "CharacterSpeedPointsNode"
        speedPointsLabel.position = CGPoint(x: 210, y: bounds.size.height - 260)
        speedPointsLabel.fontSize = 25
        speedPointsLabel.horizontalAlignmentMode = .left
        speedPointsLabel.verticalAlignmentMode = .top
        speedPointsLabel.fontColor = .brownLetters
        
        addButtonSprite = SKSpriteNode(imageNamed: directory + "addButtonChar.png")
        addButtonSprite.name = "CharacterAddPointsNode"
        addButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        addButtonSprite.position = CGPoint(x: 280, y: bounds.size.height - 290)
        addButtonSprite.size = CGSize(
            width: 40,
            height: 40
        )
       
        update(speed: "100")
        scene.addChild(speedLabel)
        scene.addChild(speedPointsLabel)
        scene.addChild(addButtonSprite)
    }
}

extension CharacterSpeedNode: VirtualBoundsSetupInterface {
    func virtualNodeBounds() -> CGRect {
        let virtualCharacterNameBounds = CGRect(x: 280.0, y: bounds.size.height - 150, width: 40, height: 40)
        
        return virtualCharacterNameBounds
    }
}
