//
//  DialogView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class DialogView {
    var dialogBoxNode: DialogBoxNode!
    var dialogTextNode: DialogTextNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        dialogBoxNode =  DialogBoxNode(bounds: viewBounds, directory: directory)
        dialogBoxNode.setupNode(with: skScene)
        
        dialogTextNode = DialogTextNode(bounds: viewBounds)
        dialogTextNode.setupNode(with: skScene)
    }
}
