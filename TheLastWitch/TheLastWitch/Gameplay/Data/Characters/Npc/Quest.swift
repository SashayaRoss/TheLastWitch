//
//  Quest.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 09/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class Quest {
    let id: Int
    var desc: String
    let type: QuestType
    let exp: Int
    var targets: [String]
    var isActive: Bool = true
    var isFinished: Bool = false
    
    init(
        id: Int,
        desc: String,
        type: QuestType,
        exp: Int,
        targets: [String]
    ) {
        self.id = id
        self.desc = desc
        self.type = type
        self.exp = exp
        self.targets = targets
    }
}
