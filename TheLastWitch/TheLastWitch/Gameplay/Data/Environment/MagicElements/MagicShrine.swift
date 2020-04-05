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
    let dialog: [String]
    let model: String = "art.scnassets/Scenes/environment/....."
    let noticeDistance: Float = 2.0
    
    init(dialog: [String]) {
        self.dialog = dialog
    }
}
