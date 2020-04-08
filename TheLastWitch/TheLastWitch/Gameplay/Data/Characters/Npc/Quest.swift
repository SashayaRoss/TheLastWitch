//
//  Quest.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 09/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

final class Quest {
    let desc: String
    let requirements: String
    let exp: Int
    
    init(
        desc: String,
        requirements: String,
        exp: Int
    ) {
        self.desc = desc
        self.requirements = requirements
        self.exp = exp
    }
}
