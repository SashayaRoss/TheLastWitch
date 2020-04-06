//
//  WolfBossModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 30/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

final class WolfBossModel: EnemyModel {
    var hp: Int = 270
    var strength: Int = 20
    var exp: Int = 200
    
    let noticeDistance: Float = 3.0
    let movementSpeedLimiter: Float = 0.5
    
    var lastAttackTime: TimeInterval = 0.0
    var isDead = false
    var isAttacking = false
}
