//
//  DialogBoxNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class DialogBoxNode {
    private var dialogSprite: SKSpriteNode!
    private var bounds: CGRect
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension DialogBoxNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        dialogSprite = SKSpriteNode(imageNamed: directory + "dialog.png")
        dialogSprite.name = "DialogBoxNode"
        dialogSprite.position = CGPoint(x: 10, y: 10)
        dialogSprite.xScale = 1.0
        dialogSprite.yScale = 1.0
        dialogSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        dialogSprite.size = CGSize(width: bounds.size.width - 20, height: 140)
       
        scene.addChild(dialogSprite)
    }
    
    func virtualNodeBounds() -> CGRect {
        var virtualDialogBounds = CGRect(x: 10.0, y: 10.0, width: bounds.size.width - 20, height: 140)
        virtualDialogBounds.origin.y = bounds.size.height - virtualDialogBounds.size.height
        
        return virtualDialogBounds
    }
}
