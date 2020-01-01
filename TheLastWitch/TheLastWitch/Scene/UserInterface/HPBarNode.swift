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
    private var hpBar: SKSpriteNode!
    private let hpBarMaxWidth: CGFloat = 150.0
    private var bounds: CGRect
    
    init(bounds: CGRect) {
        self.bounds = bounds
    }
}

extension HPBarNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        hpBar = SKSpriteNode(color: .green, size: CGSize(width: hpBarMaxWidth, height: 10))
        hpBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        hpBar.position = CGPoint(x: 10.0, y: bounds.width - 120)
        hpBar.xScale = 1.0
        hpBar.yScale = 1.0
        scene.addChild(hpBar)
    }
    
    func virtualNodeBounds() -> CGRect {
        let virtualHPBarBounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        return virtualHPBarBounds
    }
}
