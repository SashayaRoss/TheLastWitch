//
//  CharacterNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterBgNode {
    private var characterSprite: SKSpriteNode!
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension CharacterBgNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        characterSprite = SKSpriteNode(imageNamed: directory + "charBG.png")
        characterSprite.name = "CharacterNode"
        characterSprite.position = CGPoint(x: 20, y: 20)
        characterSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        characterSprite.size = CGSize(
            width: bounds.size.width - 40,
            height: bounds.size.height - 40
        )
       
        scene.addChild(characterSprite)
    }
}
