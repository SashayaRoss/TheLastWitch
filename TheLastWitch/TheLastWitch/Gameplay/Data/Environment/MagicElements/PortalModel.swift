//
//  PortalModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 10/05/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PortalModel: MagicElementsModel {
    let exp: Int = 20
    var perk: Perk
    var perkCached: Perk
    var dialog: [String]
    var dialogCached: [String]
    let model: String
    let noticeDistance: Float = 2.0
    let type: TargetType? = .bluePortal
    
    init(
        dialog: [String],
        model: String,
        perk: Perk
    ) {
        self.dialog = dialog
        self.model = model
        self.perk = perk
        
        dialogCached = dialog
        perkCached = perk
    }
    
    func resetModel() {
        perk = perkCached
        dialog = dialogCached
    }
}
