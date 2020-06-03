//
//  WolfBossModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 30/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class WolfBossModel: EnemyModel {
    let name: String
    var hp: Int = 270
    var strength: Int = 40
    var exp: Int = 200
    var type: TargetType = .boss
    let position: SCNVector3
    let model: String
    
    var noticeDistance: Float = 6.0
    var movementSpeedLimiter: Float = 3
    
    var lastAttackTime: TimeInterval = 0.0
    var isDead = false
    var isAttacking = false
    
    init(
        name: String,
        position: SCNVector3,
        model: String
    ) {
        self.name = name
        self.position = position
        self.model = model
    }
    
    func resetModel() {
         hp = 270
         strength = 40
         exp = 200
         type = .boss
         noticeDistance = 6.0
         movementSpeedLimiter = 3
         lastAttackTime = 0.0
         isDead = false
         isAttacking = false
    }
}
