//
//  VillagerModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

final class VillagerModel: NpcModel {
    //to do change to false
//    var isInteracting = true
    let noticeDistance: Float = 1.0
    let dialog: [String]
    
    init(dialog: [String]) {
        self.dialog = dialog
    }
}
