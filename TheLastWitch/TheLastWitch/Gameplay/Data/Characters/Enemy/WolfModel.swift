//
//  WolfModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

final class WolfModel: EnemyModel {
    var hp: Float = 70.0
    var strength: Float = 20.0
    var exp: Float = 50.0
    
    let noticeDistance: Float = 3.0
    let movementSpeedLimiter: Float = 0.5
    
    var lastAttackTime: TimeInterval = 0.0
    var isDead = false
    var isAttacking = false
}
