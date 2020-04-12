//
//  GameOverConfigurator.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 12/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class GameOverConfigurator {
    var gameOverNode: GameOverNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        gameOverNode = GameOverNode(bounds: viewBounds, directory: directory)
        gameOverNode.setupNode(with: skScene)
    }
}
