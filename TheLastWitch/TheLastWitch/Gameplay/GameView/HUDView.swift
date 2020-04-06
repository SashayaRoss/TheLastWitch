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
        dpadNode = DpadNode(bounds: viewBounds, directory: directory)
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
        NotificationCenter.default.addObserver(self, selector: #selector(expDidChange), name: NSNotification.Name("expChanged"), object: nil)
    }
    
    @objc private func hpDidChange(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let playerMaxHp = userInfo["playerMaxHp"] as? Int,
            let currentHp = userInfo["currentHp"] as? Int
        else {
            return
        }
        
        let v1 = CGFloat(playerMaxHp)
        let v2 = hpBarMaxWidth
        let v3 = CGFloat(currentHp)
        var currentLocalHp: CGFloat = 0.0
        
        currentLocalHp = (v2 * v3) / v1
        
        hpBarNode.updateHpColour(currentHP: currentLocalHp)

        if currentHp < 0 { currentLocalHp = 0 }
        let reduceAction = SKAction.resize(toWidth: currentLocalHp, duration: 0.3)
        hpBarNode.runAction(action: reduceAction)
    }
    
    @objc private func expDidChange(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let playerMaxExp = userInfo["playerMaxExp"] as? Int,
            let currentExp = userInfo["currentExp"] as? Int,
            let levelUp = userInfo["levelUp"] as? Bool
        else {
            return
        }
        
        let playerMaxExpLocal = CGFloat(playerMaxExp)
        let expBarMaxWidthLocal = expBarMaxWidth
        let currentExpLocal = CGFloat(currentExp)
        
        var currentDeltaExp: CGFloat = 0.0
        
        currentDeltaExp = (expBarMaxWidthLocal * currentExpLocal) / playerMaxExpLocal
        
        if levelUp {
            let addActionToMax = SKAction.resize(toWidth: expBarMaxWidth, duration: 0.3)
            let newAddActionToZero = SKAction.resize(toWidth: 0, duration: 0)
            let addActionToValue = SKAction.resize(toWidth: currentDeltaExp, duration: 0.3)
            
            currentDeltaExp = CGFloat(currentExp - playerMaxExp)
            currentDeltaExp = (expBarMaxWidthLocal * currentExpLocal) / playerMaxExpLocal

            DispatchQueue.main.async {
                self.expBarNode.runAction(action: addActionToMax)
            }
            
            let seconds = 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
               self.expBarNode.runAction(action: newAddActionToZero)
                self.expBarNode.runAction(action: addActionToValue)
            }
        } else {
            let addAction = SKAction.resize(toWidth: currentDeltaExp, duration: 0.3)
            DispatchQueue.main.async {
                self.expBarNode.runAction(action: addAction)
            }
        }
    }
}
