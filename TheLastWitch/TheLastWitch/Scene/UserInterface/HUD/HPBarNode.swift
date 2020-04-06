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
    private var directory: String
    private var barDeco: SKSpriteNode!
    
    private var hpBar: SKSpriteNode!
    private var hpBarBg: SKSpriteNode!
    private let hpBarMaxWidth: CGFloat
    
    init(bounds: CGRect, hpBarMaxWidth: CGFloat, directory: String) {
        self.bounds = bounds
        self.directory = directory
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
        hpBar = SKSpriteNode(color: .hpColour, size: CGSize(width: hpBarMaxWidth, height: 4))
        hpBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        hpBar.position = CGPoint(x: 80.0, y: bounds.height - 20)
        hpBar.name = "HPBarNode"
        
        hpBarBg = SKSpriteNode(color: .brown, size: CGSize(width: hpBarMaxWidth, height: 4))
        hpBarBg.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        hpBarBg.position = CGPoint(x: 80.0, y: bounds.height - 20)
        hpBarBg.name = "HPBarNodeBG"
        
        barDeco = SKSpriteNode(imageNamed: directory + "barDeco.png")
        barDeco.position = CGPoint(x: 80.0, y: bounds.height - 24)
        barDeco.size = CGSize(width: hpBarMaxWidth + 5, height: 12)
        barDeco.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        barDeco.name = "hpBarDeco"
        
        scene.addChild(barDeco)
        scene.addChild(hpBarBg)
        scene.addChild(hpBar)
    }
    
    func virtualNodeBounds() -> CGRect {
        let virtualHPBarBounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        return virtualHPBarBounds
    }
}
