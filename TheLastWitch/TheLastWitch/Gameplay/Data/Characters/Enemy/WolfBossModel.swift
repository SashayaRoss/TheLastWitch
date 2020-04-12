//
//  WolfBossModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 30/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit
import SceneKit

final class WolfBossModel: EnemyModel {
    let name: String
    var hp: Int = 270
    var strength: Int = 20
    var exp: Int = 200
    var type: TargetType = .boss
    let position: SCNVector3
    
    var noticeDistance: Float = 3.0
    var movementSpeedLimiter: Float = 0.5
    
    var lastAttackTime: TimeInterval = 0.0
    var isDead = false
    var isAttacking = false
    
    init(
        name: String,
        position: SCNVector3
    ) {
        self.name = name
        self.position = position
    }
    
    func resetModel() {
         hp = 270
         strength = 20
         exp = 200
         type = .boss
         noticeDistance = 3.0
         movementSpeedLimiter = 0.5
         lastAttackTime = 0.0
         isDead = false
         isAttacking = false
    }
}
