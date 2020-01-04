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
    private let viewBounds = UIScreen.main.bounds
    
    var dpadNode: DpadNode!
    var attackButtonNode: AttackButtonNode!
    var hpBarNode: HPBarNode!
    
    //MARK: lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
            
        dpadNode =  DpadNode(bounds: viewBounds)
        dpadNode.setupNode(with: skScene)

        attackButtonNode = AttackButtonNode(bounds: viewBounds)
        attackButtonNode.setupNode(with: skScene)

        hpBarNode = HPBarNode(bounds: viewBounds)
        hpBarNode.setupNode(with: skScene)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout2Doverlay()
    }
    
    deinit {}
    
    private func setup2DOverlay() {
        let width = viewBounds.width
        let height = viewBounds.height
        
        skScene = SKScene(size: CGSize(width: width, height: height))
        skScene.scaleMode = .resizeFill
        
        skScene.addChild(overlayNode)
        
        overlaySKScene = skScene
        skScene.isUserInteractionEnabled = false
    }
    
    private func layout2Doverlay() {
        overlayNode.position = CGPoint(x: 0.0, y: viewBounds.height)
    }
    
    // TO DO: remove later
    private func setupViewBounds() {
        let height = viewBounds.height - 40
        let width = viewBounds.width - 40
        
        let testNode = SKSpriteNode(color: .red, size: CGSize(width: width, height: height))
        testNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        testNode.position = CGPoint(x: viewBounds.midX, y: viewBounds.midY)
        skScene.addChild(testNode)
    }
}
