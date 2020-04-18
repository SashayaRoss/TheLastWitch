//
//  VictoryConfigurator.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 18/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class VictoryConfigurator {
    var victoryNode: VictoryNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        victoryNode = VictoryNode(bounds: viewBounds, directory: directory)
        victoryNode.setupNode(with: skScene)
    }
}
