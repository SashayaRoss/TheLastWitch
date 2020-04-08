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
    
    var activeQuests: [String] = [""]
    
    var isAttacking = false
    var isInteracting = false
    var isDead = false
}
