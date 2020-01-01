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
    
    var dpadNode: DpadNode!
    var attackButtonNode: AttackButtonNode!
    var hpBarNode: HPBarNode!
    
    //MARK: lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
            
        dpadNode =  DpadNode(bounds: bounds)
        dpadNode.setupNode(with: skScene)
        
        attackButtonNode = AttackButtonNode(bounds: bounds)
        attackButtonNode.setupNode(with: skScene)
        
        hpBarNode = HPBarNode(bounds: bounds)
        hpBarNode.setupNode(with: skScene)
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
        skScene.isUserInteractionEnabled = false
    }
    
    private func layout2Doverlay() {
        overlayNode.position = CGPoint(x: 0.0, y: bounds.size.height)
    }
}
