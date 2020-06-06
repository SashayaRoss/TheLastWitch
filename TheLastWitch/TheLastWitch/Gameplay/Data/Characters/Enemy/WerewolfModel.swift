//
//  WerewolfModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class WerewolfModel: EnemyModel {
    let name: String
   //jako słabszy przeciwnik, model wilkołaka ma poziom życia i siłę niższą, doświadczenie zdobyte za jego pokonanie również jest mniejsze w porównaniu do zdobytego za pokonanie potężniejszego przeciwnika
    var hp: Int = 90
    var strength: Int = 5
    var exp: Int = 40
    var type: TargetType = .werewolf
    let position: SCNVector3
    let model: String
    
    //maksymalna odległość w jakiej gracz zostanie zauważony
    var noticeDistance: Float = 6.0
    //prędkość poruszania postaci
    var movementSpeedLimiter: Float = 1.5
    
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
    
    //przywraca wartości początkowe przy restarcie gry
    func resetModel() {
        hp = 90
        strength = 5
        exp = 40
        type = .werewolf
        noticeDistance = 6.0
        movementSpeedLimiter = 1.5
        lastAttackTime = 0.0
        isDead = false
        isAttacking = false
    }
}
