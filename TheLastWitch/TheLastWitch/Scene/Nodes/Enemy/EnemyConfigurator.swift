//
//  EnemyConfigurator.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

final class EnemyConfigurator {
    func configure(player: Player, gameView: GameView) -> Enemy {
        
        let enemy = Enemy(enemy: player, view: gameView)
        return enemy
    }
}
