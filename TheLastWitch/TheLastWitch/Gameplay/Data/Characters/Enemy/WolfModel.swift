//
//  WolfModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit
import SceneKit

final class WolfModel: EnemyModel {
    let name: String
    var hp: Int = 10
    var strength: Int = 20
    var exp: Int = 60
    var type: TargetType = .golem
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
        hp = 10
        strength = 20
        exp = 60
        type = .golem
        noticeDistance = 3.0
        movementSpeedLimiter = 0.5
        lastAttackTime = 0.0
        isDead = false
        isAttacking = false
    }
}
