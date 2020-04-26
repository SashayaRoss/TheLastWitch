//
//  SceneConfigurator.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 01/02/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

final class SceneConfigurator {
    func setup(state: GameState) -> SCNScene? {
        let sceneName: String
        switch state {
        case .newGame:
            sceneName = "art.scnassets/Scenes/World/WelcomeScreenScene.scn"
        case .transition:
            sceneName = "art.scnassets/Scenes/World/TransitionScene.scn"
        default:
            sceneName = "art.scnassets/Scenes/World/ForestScene/ForestScene.scn"
        }
        let mainScene = SCNScene(named: sceneName)
        guard let scene = mainScene else { return mainScene }

        return scene
    }
}
