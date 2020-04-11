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
    var dialog: [String]
    let quest: Quest?
    let model: String
    
    let pathFinder: [PathFinder?]
    
    init(
        dialog: [String],
        pathFinder: [PathFinder],
        quest: Quest? = nil,
        model: String
    ) {
        self.dialog = dialog
        self.pathFinder = pathFinder
        self.quest = quest
        self.model = model
    }
    
    func updateDialogWithQuest() {
        guard
            let questDesc = quest?.desc,
            let active = quest?.isActive
        else {
            return
        }
        if active {
            let intro = "NEW QUEST: "
            dialog.append(intro + questDesc)
        }
    }
    
    func finishQuestDialogUpdate(quest: String) {
        let desc = "NEW QUEST: " + quest
        dialog = dialog.filter(){$0 != desc}
        
        let thankYou = "Thank you brave witch! \n[FINISHED QUEST: " + quest + "]"
        dialog.append(thankYou)
    }
}
