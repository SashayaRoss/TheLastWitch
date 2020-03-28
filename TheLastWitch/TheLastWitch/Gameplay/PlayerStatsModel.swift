//
//  PlayerStatsModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

final class PlayerStatsModel {
    let maxHpPoints: Float = 100.0
    var hpPoints: Float = 100.0
    
    let maxExpPoints: Float = 100.0
    var expPoints: Float = 0
    
    var isAttacking = false
    var isDead = false
}
