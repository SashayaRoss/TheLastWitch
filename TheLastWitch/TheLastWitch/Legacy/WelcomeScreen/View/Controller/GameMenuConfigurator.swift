//
//  GameMenuConfigurator.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

final class GameMenuConfigurator {
    func configure() -> GameMenuController {
        
        let layoutManager = GameMenuLayoutManager()
        let gameMenuController = GameMenuController(layoutManager: layoutManager)
        
        return gameMenuController
    }
}
