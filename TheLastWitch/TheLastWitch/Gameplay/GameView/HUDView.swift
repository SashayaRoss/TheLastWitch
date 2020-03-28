//
//  HUDView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class HUDView {
    private let hpBarMaxWidth: CGFloat = 150.0
    private let expBarMaxWidth: CGFloat = 100.0
    
    var dpadNode: DpadNode!
    var attackButtonNode: AttackButtonNode!
    var characterButtonNode: CharacterButtonNode!
    var hpBarNode: HPBarNode!
    var expBarNode: EXPBarNode!
    var optionsButtonNode: OptionsButtonNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        dpadNode =  DpadNode(bounds: viewBounds, directory: directory)
        dpadNode.setupNode(with: skScene)

        attackButtonNode = AttackButtonNode(bounds: viewBounds, directory: directory)
        attackButtonNode.setupNode(with: skScene)

        hpBarNode = HPBarNode(bounds: viewBounds, hpBarMaxWidth: hpBarMaxWidth, directory: directory)
        hpBarNode.setupNode(with: skScene)
        
        expBarNode = EXPBarNode(bounds: viewBounds, expBarMaxWidth: expBarMaxWidth, directory: directory)
        expBarNode.setupNode(with: skScene)
        
        characterButtonNode = CharacterButtonNode(bounds: viewBounds, directory: directory)
        characterButtonNode.setupNode(with: skScene)
        
        optionsButtonNode = OptionsButtonNode(bounds: viewBounds, directory: directory)
        optionsButtonNode.setupNode(with: skScene)
        
        setupObservers()
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
        
//             100 * x = 150 * 90 -> x = (150 * 90) / 100
        currentLocalHp = (v2 * v3) / v1
        
        hpBarNode.updateHpColour(currentHP: currentLocalHp)

        if currentHp < 0 { currentLocalHp = 0 }
        let reduceAction = SKAction.resize(toWidth: currentLocalHp, duration: 0.3)
        hpBarNode.runAction(action: reduceAction)
    }
}
