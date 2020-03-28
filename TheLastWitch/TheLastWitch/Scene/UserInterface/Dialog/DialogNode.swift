//
//  DialogNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class DialogNode {
    private var dpadSprite: SKSpriteNode!
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension DialogNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
//        dpadSprite = SKSpriteNode(imageNamed: "art.scnassets/UI/HUD/Layout/dPad.png")
        dpadSprite.color = .blue
        dpadSprite.position = CGPoint(x: 10, y: 10)
        dpadSprite.xScale = 1.0
        dpadSprite.yScale = 1.0
        dpadSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        dpadSprite.size = CGSize(width: bounds.origin.x - 40, height: bounds.origin.y - 200)
        scene.addChild(dpadSprite)
    }
    
    func virtualNodeBounds() -> CGRect {
        var virtualDpadBounds = CGRect(x: 10.0, y: 10.0, width: bounds.origin.x - 40, height: bounds.origin.y - 200)
        virtualDpadBounds.origin.y = bounds.size.height - virtualDpadBounds.size.height
        
        return virtualDpadBounds
    }
}
