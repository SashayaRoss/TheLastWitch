//
//  PlayerCharacterMapping.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 09/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

protocol PlayerCharacterMapping {
    func map(entity: PlayerModel) -> PlayerCharacterStatsModel
}
