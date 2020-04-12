//
//  MagicShrine.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

final class MagicShrine: MagicElementsModel {
    let exp: Int = 20
    var perk: Perk
    var dialog: [String]
    let model: String
    let noticeDistance: Float = 2.0
    let type: TargetType? = nil
    
    init(
        dialog: [String],
        model: String,
        perk: Perk
    ) {
        self.dialog = dialog
        self.model = model
        self.perk = perk
    }
}
