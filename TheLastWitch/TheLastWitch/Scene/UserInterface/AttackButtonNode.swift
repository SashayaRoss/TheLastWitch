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
    
    init(bounds: CGRect) {
        self.bounds = bounds
    }
}

extension AttackButtonNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        attactButtonSprite = SKSpriteNode(imageNamed: "art.scnassets/Assets/attact1.png")
        attactButtonSprite.position = CGPoint(x: bounds.size.width + 20, y: 50)
        attactButtonSprite.xScale = 1.0
        attactButtonSprite.yScale = 1.0
        attactButtonSprite.size = CGSize(width: 60.0, height: 60.0)
        attactButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        attactButtonSprite.name = "attackButton"
        scene.addChild(attactButtonSprite)
    }
    
    func virtualNodeBounds() -> CGRect {
        var virtualDPadBounds = CGRect(x: 10.0, y: 10.0, width: 150.0, height: 150.0)
        virtualDPadBounds.origin.y = bounds.size.height - virtualDPadBounds.size.height - virtualDPadBounds.origin.y
        
        return virtualDPadBounds
    }
}
