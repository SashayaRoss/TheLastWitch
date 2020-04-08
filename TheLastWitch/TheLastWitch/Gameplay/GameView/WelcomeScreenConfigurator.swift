//
//  WelcomeScreenView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class WelcomeScreenConfigurator {
    var backgoundNode: WelcomeScreenBackgroundNode!
    var tapToPlayNode: DialogTextNode!
    
    func setup(skScene: SKScene, directory: String, viewBounds: CGRect) {
        backgoundNode = WelcomeScreenBackgroundNode(bounds: viewBounds, directory: directory)
        backgoundNode.setupNode(with: skScene)
        
        tapToPlayNode = DialogTextNode(bounds: viewBounds)
        tapToPlayNode.setupNode(with: skScene)
        
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(stopVideo), name: NSNotification.Name("stopVideo"), object: nil)
    }
    
    @objc func stopVideo() {
        backgoundNode.stopReplay()
    }
}
