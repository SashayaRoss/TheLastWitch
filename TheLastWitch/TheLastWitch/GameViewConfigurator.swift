//
//  GameViewConfigurator.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 01/02/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

final class GameViewConfigurator {
    func setup() -> SCNScene? {
        
        let mainScene = SCNScene(named: "art.scnassets/Scenes/Stage1.scn")
        guard let scene = mainScene else { return mainScene}
        
        return scene
    }
}
