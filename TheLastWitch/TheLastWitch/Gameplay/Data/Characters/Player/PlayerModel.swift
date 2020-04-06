//
//  PlayerModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

final class PlayerModel {
    let maxHpPoints: Int = 100
    var hpPoints: Int = 100
    
    let maxExpPoints: Int = 100
    var expPoints: Int = 0
    
    var speed: Float = 1.8
    var level: Int = 1
    
    var isAttacking = false
    var isInteracting = false
    var isDead = false
}
