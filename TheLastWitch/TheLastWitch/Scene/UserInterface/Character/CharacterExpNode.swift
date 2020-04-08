//
//  ExpNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 08/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterExpNode {
    private var exp: SKLabelNode!
    private let expTag = "EXP"
    
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
    
    func updateExp(current: String, max: String) {
        exp.text = "\(expTag): \(current) / \(max)"
    }
}

extension CharacterExpNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        exp = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        exp.name = "CharacterNameTextNode"
        exp.fontSize = 24
        exp.horizontalAlignmentMode = .left
        exp.verticalAlignmentMode = .top
        exp.fontColor = .brownLetters
        exp.position = CGPoint(
            x: 75,
            y: bounds.size.height - 110
        )
        
        updateExp(current: "0", max: "100")
        scene.addChild(exp)
    }
}
