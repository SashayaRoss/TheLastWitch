//
//  DpadNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class DpadNode {
    private var dpadSprite: SKSpriteNode!
    private var bounds: CGRect
    
    init(bounds: CGRect) {
        self.bounds = bounds
    }
}

extension DpadNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        dpadSprite = SKSpriteNode(imageNamed: "art.scnassets/Assets/dpad.png")
        dpadSprite.xScale = 1.0
        dpadSprite.yScale = 1.0
        dpadSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        dpadSprite.size = CGSize(width: 150.0, height: 150.0)
        scene.addChild(dpadSprite)
    }
    
    func virtualNodeBounds() -> CGRect {
        var virtualAttactButtonBounds = CGRect(x: bounds.width - 110, y: 50.0, width: 60.0, height: 60.0)
        virtualAttactButtonBounds.origin.y = bounds.size.height - virtualAttactButtonBounds.size.height - virtualAttactButtonBounds.origin.y
        
        return virtualAttactButtonBounds
    }
}
