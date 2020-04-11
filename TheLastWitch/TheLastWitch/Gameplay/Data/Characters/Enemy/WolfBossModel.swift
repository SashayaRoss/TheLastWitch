//
//  WolfBossModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 30/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

final class WolfBossModel: EnemyModel {
    let name: String
    var hp: Int = 270
    var strength: Int = 20
    var exp: Int = 200
    
    let noticeDistance: Float = 3.0
    let movementSpeedLimiter: Float = 0.5
    
    let pathFinder: [PathFinder?]
    
    var lastAttackTime: TimeInterval = 0.0
    var isDead = false
    var isAttacking = false
    
    init(
        name: String,
        pathFinder: [PathFinder]
    ) {
        self.name = name
        self.pathFinder = pathFinder
    }
}
