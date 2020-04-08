//
//  VillagerModel.swift
//  TheLastWitchJ
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

final class VillagerModel: NpcModel {
    let noticeDistance: Float = 1.0
    let dialog: [String]
    let quest: Quest? = Quest(desc: "Kill a wolf", requirements: "", exp: 0)
    let model: String = "art.scnassets/Scenes/Characters/Hero/idle"
    
    let pathFinder: [PathFinder?]
    
    init(dialog: [String], pathFinder: [PathFinder]) {
        self.dialog = dialog
        self.pathFinder = pathFinder
    }
}
