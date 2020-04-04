//
//  EXPBarNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 08/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class EXPBarNode {
    private var bounds: CGRect
    private var directory: String
    private var barDeco: SKSpriteNode!
    
    private var expBar: SKSpriteNode!
    private let expBarMaxWidth: CGFloat
    
    init(bounds: CGRect, expBarMaxWidth: CGFloat, directory: String) {
        self.bounds = bounds
        self.directory = directory
        self.expBarMaxWidth = expBarMaxWidth
    }
    
    func runAction(action: SKAction) {
        expBar.run(action)
    }
}

extension EXPBarNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        expBar = SKSpriteNode(color: .expColour, size: CGSize(width: 0, height: 4))
        expBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        expBar.position = CGPoint(x: 95.0, y: bounds.height - 35)
        expBar.name = "EXPBarNode"
        
        barDeco = SKSpriteNode(imageNamed: directory + "barDeco.png")
        barDeco.position = CGPoint(x: 95.0, y: bounds.height - 39)
        barDeco.size = CGSize(width: expBarMaxWidth + 5, height: 12)
        barDeco.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        barDeco.name = "expBarDeco"
        
        scene.addChild(barDeco)
        scene.addChild(expBar)
    }
    
    func virtualNodeBounds() -> CGRect {
        let virtualEXPBarBounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        return virtualEXPBarBounds
    }
}
