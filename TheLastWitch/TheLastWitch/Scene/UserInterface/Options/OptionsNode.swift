//
//  OptionsNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class OptionsNode {
    private var optionsSprite: SKSpriteNode!
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension OptionsNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        optionsSprite = SKSpriteNode(imageNamed: directory + "optionsBG.jpg")
        optionsSprite.name = "OptionsNode"
        optionsSprite.position = CGPoint(x: 20, y: 20)
        optionsSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        optionsSprite.size = CGSize(width: bounds.size.width - 40, height: bounds.size.height - 40)
       
        scene.addChild(optionsSprite)
    }
    
    func virtualNodeBounds() -> CGRect {
        var virtualOptionsBounds = CGRect(x: 20.0, y: 20.0, width: bounds.size.width - 40, height: bounds.size.height - 40)
        virtualOptionsBounds.origin.y = bounds.size.height - virtualOptionsBounds.size.height
        
        return virtualOptionsBounds
    }
}
