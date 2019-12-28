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
    
    private var dpadSprite: SKSpriteNode!
    private var attactButtonSprite: SKSpriteNode!
    
    private var hpBar: SKSpriteNode!
    private let hpBarMaxWidth: CGFloat = 150.0
    
    //MARK: lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
        
        setupDpad(with: skScene)
        setupAttactButton(with: skScene)
        setUpHpBar(with: skScene)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout2Doverlay()
    }
    
    deinit {
        
    }
    
    //MARK: overlay functions
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
    
    //MARK: D-Pad
    private func setupDpad(with scene: SKScene) {
        dpadSprite = SKSpriteNode(imageNamed: "art.scnassets/Assets/dpad.png")
        dpadSprite.xScale = 1.0
        dpadSprite.yScale = 1.0
        dpadSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        dpadSprite.size = CGSize(width: 150.0, height: 150.0)
        scene.addChild(dpadSprite)
    }
    
    func virtualDPadBounds() -> CGRect {
        var virtualDPadBounds = CGRect(x: 10.0, y: 10.0, width: 150.0, height: 150.0)
        virtualDPadBounds.origin.y = bounds.size.height - virtualDPadBounds.size.height - virtualDPadBounds.origin.y
        
        return virtualDPadBounds
    }
    
    //MARK: attack button
    private func setupAttactButton(with scene: SKScene) {
        attactButtonSprite = SKSpriteNode(imageNamed: "art.scnassets/Assets/attact1.png")
        attactButtonSprite.position = CGPoint(x: bounds.size.width + 20, y: 50)
        attactButtonSprite.xScale = 1.0
        attactButtonSprite.yScale = 1.0
        attactButtonSprite.size = CGSize(width: 60.0, height: 60.0)
        attactButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        attactButtonSprite.name = "attackButton"
        scene.addChild(attactButtonSprite)
    }
    
    func virtualAttackButtonBounds() -> CGRect {
        var virtualAttactButtonBounds = CGRect(x: bounds.width - 110, y: 50.0, width: 60.0, height: 60.0)
        virtualAttactButtonBounds.origin.y = bounds.size.height - virtualAttactButtonBounds.size.height - virtualAttactButtonBounds.origin.y
        
        return virtualAttactButtonBounds
    }
    
    private func setUpHpBar(with scene: SKScene) {
        hpBar = SKSpriteNode(color: .green, size: CGSize(width: hpBarMaxWidth, height: 20))
        hpBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        hpBar.position = CGPoint(x: 15.0, y: 250)
        hpBar.xScale = 1.0
        hpBar.yScale = 1.0
        scene.addChild(hpBar)
    }
}
