//
//  EnemyModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

protocol EnemyModel {
    var name: String { get }
    var hp: Int { get set }
    var strength: Int { get set }
    var exp: Int { get set }
    var type: TargetType { get }
    
    var noticeDistance: Float { get }
    var movementSpeedLimiter: Float { get }
    
    var isDead: Bool { get set }
    var isAttacking: Bool { get set }
    var lastAttackTime: TimeInterval { get set }
}
