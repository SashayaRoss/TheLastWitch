//
//  EnemyModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

protocol EnemyModel {
    var hp: Float { get set }
    var strength: Float { get set }
    var exp: Float { get set }
    
    var noticeDistance: Float { get }
    var movementSpeedLimiter: Float { get }
    
    var isDead: Bool { get set }
    var isAttacking: Bool { get set }
    var lastAttackTime: TimeInterval { get set }
}
