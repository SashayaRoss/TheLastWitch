//
//  CharacterView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterConfigurator {
    var characterNodeBg: CharacterBgNode!
    var characterName: CharacterNameNode!
    var questBg: CharacterQuestBgNode!
    var questList: CharacterQuestListNode!
    var goBack: GoBackButtonNode!
    var exp: CharacterExpNode!
    var health: CharacterHealthNode!
    var magic: CharacterMagicNode!
    var speed: CharacterSpeedNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        characterNodeBg = CharacterBgNode(bounds: viewBounds, directory: directory)
        characterNodeBg.setupNode(with: skScene)
        
        characterName = CharacterNameNode(bounds: viewBounds, directory: directory)
        characterName.setupNode(with: skScene)
        
        questBg = CharacterQuestBgNode(bounds: viewBounds, directory: directory)
        questBg.setupNode(with: skScene)
        
        questList = CharacterQuestListNode(bounds: viewBounds, directory: directory)
        questList.setupNode(with: skScene)
        
        goBack = GoBackButtonNode(bounds: viewBounds, directory: directory)
        goBack.setupNode(with: skScene)
        
        exp = CharacterExpNode(bounds: viewBounds, directory: directory)
        exp.setupNode(with: skScene)
        
        health = CharacterHealthNode(bounds: viewBounds, directory: directory)
        health.setupNode(with: skScene)
        
        magic = CharacterMagicNode(bounds: viewBounds, directory: directory)
        magic.setupNode(with: skScene)
        
        speed = CharacterSpeedNode(bounds: viewBounds, directory: directory)
        speed.setupNode(with: skScene)
        
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(levelUpdate), name: NSNotification.Name("levelUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(expUpdate), name: NSNotification.Name("expUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(healthUpdate), name: NSNotification.Name("healthUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(speedUpdate), name: NSNotification.Name("speedUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(magicUpdate), name: NSNotification.Name("magicUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(questUpdate), name: NSNotification.Name("questsUpdate"), object: nil)
    }
    
    @objc private func levelUpdate(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let currentLevel = userInfo["level"] as? String,
            let currentPoints = userInfo["levelPoints"] as? String
        else {
            return
        }
        
        characterName.updateLevel(newLevel: currentLevel, points: currentPoints)
    }
    
    @objc private func expUpdate(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let maxExp = userInfo["expPoints"] as? String,
            let currentExp = userInfo["currentPoints"] as? String
        else {
            return
        }
        
        exp.update(current: currentExp, max: maxExp)
    }
    
    @objc private func healthUpdate(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let points = userInfo["healthPoints"] as? String,
            let button = userInfo["button"] as? Bool
        else {
            return
        }
        health.update(health: points)
        health.button(isVisible: button)
    }
    
    @objc private func speedUpdate(notification: Notification) {
       guard
            let userInfo = notification.userInfo as? [String: Any],
            let points = userInfo["speedPoints"] as? String,
            let button = userInfo["button"] as? Bool
        else {
            return
        }
        speed.update(speed: points)
        speed.button(isVisible: button)
    }
    
    @objc private func magicUpdate(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let points = userInfo["magicPoints"] as? String,
            let button = userInfo["button"] as? Bool
        else {
            return
        }
        magic.update(magic: points)
        magic.button(isVisible: button)
    }
    
    @objc private func questUpdate(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let list = userInfo["questList"] as? String
        else {
            return
        }
        questList.updateQuestList(quest: list)
    }
}
