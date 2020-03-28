//
//  CharacterView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterView {
    var characterNode: CharacterNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        characterNode = CharacterNode(bounds: viewBounds, directory: directory)
        characterNode.setupNode(with: skScene)
    }
}
