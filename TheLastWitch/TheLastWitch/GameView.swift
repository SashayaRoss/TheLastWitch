//
//  GameView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 26/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

// holds SpriteKit 2D UI
class GameView: SCNView {

    private var skScene: SKScene!
    private let overlayNode = SKNode()
    
    //MARK: lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
        
        
        DpadNode(bounds: bounds).setupNode(with: skScene)
        AttackButtonNode(bounds: bounds).setupNode(with: skScene)
        HPBarNode(bounds: bounds).setupNode(with: skScene)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout2Doverlay()
    }
    
    deinit {}
    
    private func setup2DOverlay() {
        let w = bounds.size.width
        let h = bounds.size.height
        
        skScene = SKScene(size: CGSize(width: w, height: h))
        skScene.scaleMode = .resizeFill
        
        skScene.addChild(overlayNode)
        overlayNode.position = CGPoint(x: 0.0, y: h)
        
        overlaySKScene = skScene
        skScene.isUserInteractionEnabled = true
    }
    
    private func layout2Doverlay() {
        overlayNode.position = CGPoint(x: 0.0, y: bounds.size.height)
    }
}
