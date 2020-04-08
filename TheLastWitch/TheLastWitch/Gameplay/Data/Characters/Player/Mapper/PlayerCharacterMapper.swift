//
//  PlayerCharacterMapper.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 09/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

final class PlayerCharacterMapper: PlayerCharacterMapping {
    func map(entity: PlayerModel) -> PlayerCharacterStatsModel {
        let isAddButtonActive = entity.levelPoints != 0
        let questList = entity.activeQuests.joined(separator: "\n- ")
        
        return PlayerCharacterStatsModel(
            level: String(entity.level),
            levelPoints: String(entity.levelPoints),
            currentExp: String(entity.expPoints),
            maxExp: String(entity.maxExpPoints
            ),
            health: String(entity.maxHpPoints),
            magic: String(entity.maxMagic * 100),
            speed: String(entity.maxSpeed * 100),
            questList: questList,
            isAddButtonActive: isAddButtonActive
        )
    }
}
