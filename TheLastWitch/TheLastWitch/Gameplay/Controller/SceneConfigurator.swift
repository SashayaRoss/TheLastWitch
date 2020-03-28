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
    func setup(sceneName: String) -> SCNScene? {

        let mainScene = SCNScene(named: sceneName)
        guard let scene = mainScene else { return mainScene}

        return scene
    }
}
