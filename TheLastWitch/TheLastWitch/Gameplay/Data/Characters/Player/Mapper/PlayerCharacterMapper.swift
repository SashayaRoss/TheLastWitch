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

        let activeQuestList = entity.quests.map {
            if $0.isFinished == false {
                return $0.isActive == true ? $0.desc : ($0.desc + " [FINISHED]")
            } else {
                return nil
            }
        }.compactMap({
            $0
        }).joined(separator: "\n- ")
        
        return PlayerCharacterStatsModel(
            level: String(entity.level),
            levelPoints: String(entity.levelPoints),
            currentExp: String(entity.expPoints),
            maxExp: String(entity.maxExpPoints),
            health: String(entity.maxHpPoints),
            magic: String(Int(entity.maxMagic * 100)),
            speed: String(Int(entity.maxSpeed * 100)),
            questList: activeQuestList,
            isAddButtonActive: isAddButtonActive
        )
    }
}
