//
//  OptionsView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class OptionsView {
    var optionsNode: OptionsNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        optionsNode = OptionsNode(bounds: viewBounds, directory: directory)
        optionsNode.setupNode(with: skScene)
    }
}
