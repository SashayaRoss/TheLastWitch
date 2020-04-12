//
//  OptionsView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class OptionsConfigurator {
    var backgroundNode: OptionsNode!
    var headerNode: OptionsHeaderNode!
    var newGame: OptionsNewGameNode!
    var devMode: OptionsDevModeNode!
    var music: OptionsMusicNode!
    var goBack: GoBackButtonNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        backgroundNode = OptionsNode(bounds: viewBounds, directory: directory)
        backgroundNode.setupNode(with: skScene)
        
        headerNode = OptionsHeaderNode(bounds: viewBounds, directory: directory)
        headerNode.setupNode(with: skScene)
        
        newGame = OptionsNewGameNode(bounds: viewBounds, directory: directory)
        newGame.setupNode(with: skScene)
        
        devMode = OptionsDevModeNode(bounds: viewBounds, directory: directory)
        devMode.setupNode(with: skScene)
        
        music = OptionsMusicNode(bounds: viewBounds, directory: directory)
        music.setupNode(with: skScene)
        
        let goBackButtonDirectory = "art.scnassets/UI/Character/"
        goBack = GoBackButtonNode(bounds: viewBounds, directory: goBackButtonDirectory)
        goBack.setupNode(with: skScene)
    }
}
