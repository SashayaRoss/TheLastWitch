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
    private var size = 150.0
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension DpadNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        dpadSprite = SKSpriteNode(imageNamed: directory + "dPad.png")
        dpadSprite.name = "DpadNode"
        dpadSprite.position = CGPoint(x: 10, y: 10)
        dpadSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        dpadSprite.size = CGSize(width: size, height: size)
        
        scene.addChild(dpadSprite)
    }
    
    func virtualNodeBounds() -> CGRect {
        var virtualDpadBounds = CGRect(x: 10.0, y: 10.0, width: size, height: size)
        virtualDpadBounds.origin.y = bounds.size.height - virtualDpadBounds.size.height
        
        return virtualDpadBounds
    }
}
