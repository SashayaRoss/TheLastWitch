//
//  PlayerModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

final class PlayerModel {
    var maxHpPoints: Int = 100
    var hpPoints: Int = 100
    
    var maxExpPoints: Int = 100
    var expPoints: Int = 0
    
    var maxSpeed: Float = 1.8
    var maxMagic: Float = 0.5
    var level: Int = 1
    var levelPoints: Int = 2
    
    //TODO: change init
    var quests: [Quest] = [Quest(id: 1, desc: "\n- Find magic portal", type: .discover, exp: 100, targets: [.bluePortal])]
    var currentInteraction: CurrentInteraction = .none
    
    var isAttacking = false
    var isInteracting = false
    var isDead = false
    
    func resetModel() {
        maxHpPoints = 100
        hpPoints = 100
        maxExpPoints = 100
        expPoints = 0
        maxSpeed = 1.8
        maxMagic = 0.5
        level = 1
        levelPoints = 2
        quests = [Quest(id: 1, desc: "\n- Find magic portal", type: .discover, exp:100, targets: [.bluePortal])]
        currentInteraction = .none
        isAttacking = false
        isInteracting = false
        isDead = false
    }
}
