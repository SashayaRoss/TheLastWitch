//
//  AttackButtonNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class AttackButtonNode {
    private var attactButtonSprite: SKSpriteNode!
    private var bounds: CGRect
    private var size = 60.0
    
    init(bounds: CGRect) {
        self.bounds = bounds
    }
}

extension AttackButtonNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        attactButtonSprite = SKSpriteNode(imageNamed: "art.scnassets/Assets/GameScene/fireAttackLogo.png")
        attactButtonSprite.position = CGPoint(x: bounds.width - 70.0, y: 20)
        attactButtonSprite.xScale = 1.0
        attactButtonSprite.yScale = 1.0
        attactButtonSprite.size = CGSize(width: size, height: size)
        attactButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        attactButtonSprite.name = "attackButton"
        scene.addChild(attactButtonSprite)
    }
    
    func virtualNodeBounds() -> CGRect {
        var virtualNodeBounds = CGRect(x: 10.0, y: 10.0, width: size, height: size)
        virtualNodeBounds.origin.y = bounds.size.height - virtualNodeBounds.size.height
        virtualNodeBounds.origin.x = bounds.size.width - virtualNodeBounds.size.width
        
        return virtualNodeBounds
    }
}
