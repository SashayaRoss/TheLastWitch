//
//  NpcDialog.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 30/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

final class NpcDialog {
    // npcName: DialogArray
    var dialogList: [String: [String]] = [:]
    
    private func updateVillager() {
        dialogList = ["Villager": ["1. Hello", "2 Im a villager", "3 life is fun!"]]
    }
}
