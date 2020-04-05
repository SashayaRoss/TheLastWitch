//
//  WelcomeScreenView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class WelcomeScreenView {
    var backgoundNode: DialogBoxNode!
    var tapToPlayNode: DialogTextNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        backgoundNode =  DialogBoxNode(bounds: viewBounds, directory: directory)
        backgoundNode.setupNode(with: skScene)
        
        tapToPlayNode = DialogTextNode(bounds: viewBounds)
        tapToPlayNode.setupNode(with: skScene)
    }
}
