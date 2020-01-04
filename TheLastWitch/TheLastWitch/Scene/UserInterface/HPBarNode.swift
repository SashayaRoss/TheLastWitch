//
//  HPBarNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class HPBarNode {
    private var bounds: CGRect
    
    private var hpBar: SKSpriteNode!
    private let hpBarMaxWidth: CGFloat = 150.0
    
    private var expBar: SKSpriteNode!
    private let expBarMaxWidth: CGFloat = 100.0
    
    init(bounds: CGRect) {
        self.bounds = bounds
    }
}

extension HPBarNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        hpBar = SKSpriteNode(color: .green, size: CGSize(width: hpBarMaxWidth, height: 10))
        hpBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        hpBar.position = CGPoint(x: 10.0, y: bounds.height - 20)
        hpBar.xScale = 1.0
        hpBar.yScale = 1.0
        
        expBar = SKSpriteNode(color: .yellow, size: CGSize(width: expBarMaxWidth, height: 10))
        expBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        expBar.position = CGPoint(x: 10.0, y: bounds.height - 35)
        expBar.xScale = 1.0
        expBar.yScale = 1.0
        
        scene.addChild(expBar)
        scene.addChild(hpBar)
    }
    
    func virtualNodeBounds() -> CGRect {
        let virtualHPBarBounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        return virtualHPBarBounds
    }
}
