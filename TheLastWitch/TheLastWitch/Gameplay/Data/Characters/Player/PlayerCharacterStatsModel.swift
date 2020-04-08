//
//  PlayerCharacterStatsModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 09/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

final class PlayerCharacterStatsModel {
    let level: String
    let levelPoints: String
    let currentExp: String
    let maxExp: String
    let health: String
    let magic: String
    let speed: String
    let questList: String
    let isAddButtonActive: Bool
    
    init(
        level: String,
        levelPoints: String,
        currentExp: String,
        maxExp: String,
        health: String,
        magic: String,
        speed: String,
        questList: String,
        isAddButtonActive: Bool
    ) {
        self.level = level
        self.levelPoints = levelPoints
        self.currentExp = currentExp
        self.maxExp = maxExp
        self.health = health
        self.magic = magic
        self.speed = speed
        self.questList = questList
        self.isAddButtonActive = isAddButtonActive
    }
}
