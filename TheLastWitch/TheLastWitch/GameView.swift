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
final class GameView: SCNView {

    private var skScene: SKScene!
    private let overlayNode = SKNode()
    private let viewBounds = UIScreen.main.bounds
    
    var dpadNode: DpadNode!
    var attackButtonNode: AttackButtonNode!
    var hpBarNode: HPBarNode!
    
     private let hpBarMaxWidth: CGFloat = 150.0
    
    //MARK: lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
        setupObservers()
            
        dpadNode =  DpadNode(bounds: viewBounds)
        dpadNode.setupNode(with: skScene)

        attackButtonNode = AttackButtonNode(bounds: viewBounds)
        attackButtonNode.setupNode(with: skScene)

        hpBarNode = HPBarNode(bounds: viewBounds, hpBarMaxWidth: hpBarMaxWidth)
        hpBarNode.setupNode(with: skScene)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout2Doverlay()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
    
    //MARK:- internal functions
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(hpDidChange), name: NSNotification.Name("hpChanged"), object: nil)
    }
    
    @objc private func hpDidChange(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let playerMaxHp = userInfo["playerMaxHp"] as? Float,
            let currentHp = userInfo["currentHp"] as? Float
        else {
            return
        }
        
        let v1 = CGFloat(playerMaxHp)
        let v2 = hpBarMaxWidth
        let v3 = CGFloat(currentHp)
        var currentLocalHp: CGFloat = 0.0
        
        // 100 * x = 150 * 90 -> x = (150 * 90) / 100
        currentLocalHp = (v2 * v3) / v1
        
        hpBarNode.updateHpColour(currentHP: currentLocalHp)
        
        if currentHp < 0 { currentLocalHp = 0 }
        let reduceAction = SKAction.resize(toWidth: currentLocalHp, duration: 0.3)
        hpBarNode.runAction(action: reduceAction)
    }
}
