//
//  OptionsButtonNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class OptionsButtonNode {
    private var optionsButtonSprite: SKSpriteNode!
    private var bounds: CGRect
    private var size = 40.0
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension OptionsButtonNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        optionsButtonSprite = SKSpriteNode(imageNamed: directory + "optionsLogo.png")
        optionsButtonSprite.position = CGPoint(x: bounds.width - 50.0, y: bounds.height - 50.0)
        optionsButtonSprite.xScale = 1.0
        optionsButtonSprite.yScale = 1.0
        optionsButtonSprite.size = CGSize(width: size, height: size)
        optionsButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        optionsButtonSprite.name = "optionsButton"
        
        scene.addChild(optionsButtonSprite)
    }
    
    func virtualNodeBounds() -> CGRect {
        var virtualNodeBounds = CGRect(x: 10.0, y: 10.0, width: size + 20, height: size + 20)
        virtualNodeBounds.origin.y = virtualNodeBounds.size.height - 40
        virtualNodeBounds.origin.x = bounds.size.width - virtualNodeBounds.size.width

        return virtualNodeBounds
    }
}
