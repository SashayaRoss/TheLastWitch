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
    private let hpBarMaxWidth: CGFloat
    
    init(bounds: CGRect, hpBarMaxWidth: CGFloat) {
        self.bounds = bounds
        self.hpBarMaxWidth = hpBarMaxWidth
    }
    func runAction(action: SKAction) {
        hpBar.run(action)
    }
    
    func updateHpColour(currentHP: CGFloat) {
        if currentHP <= hpBarMaxWidth / 3.5 {
            hpBar.color = UIColor.red
        } else if currentHP <= hpBarMaxWidth / 2 {
            hpBar.color = UIColor.orange
        }
    }
}

extension HPBarNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        let hp = ColourBase().green()
        
        hpBar = SKSpriteNode(color: hp, size: CGSize(width: hpBarMaxWidth, height: 10))
        hpBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        hpBar.position = CGPoint(x: 85.0, y: bounds.height - 20)
        hpBar.xScale = 1.0
        hpBar.yScale = 1.0
        
        scene.addChild(hpBar)
    }
    
    func virtualNodeBounds() -> CGRect {
        let virtualHPBarBounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        return virtualHPBarBounds
    }
}