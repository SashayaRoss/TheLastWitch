//
//  GameView.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 26/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

// holds SpriteKit 2D UI for gameplay
final class GameView: SCNView {
    private var skScene: SKScene!
    private let overlayNode = SKNode()
    private let viewBounds = UIScreen.main.bounds
    
    let hudView = HUDView()
    let characterView = CharacterView()
    let dialogView = DialogView()
    let optionsView = OptionsView()
    
    let welcomeScreenView = WelcomeScreenNode()
    
    //MARK: lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
        setupHUD()
    }
    
    func setupHUD() {
        let directory = "art.scnassets/UI/HUD/"
        hudView.setup(skScene: skScene, directory: directory, viewBounds: viewBounds)
    }
    
    func setupCharacter() {
        let directory = "art.scnassets/UI/Character/"
        characterView.setup(skScene: skScene, directory: directory, viewBounds: viewBounds)
    }
    
    func setupDialog() {
        let directory = "art.scnassets/UI/Dialog/"
        dialogView.setup(skScene: skScene, directory: directory, viewBounds: viewBounds)
    }
    
    func setupOptions() {
        let directory = "art.scnassets/UI/Options/"
        optionsView.setup(skScene: skScene, directory: directory, viewBounds: viewBounds)
    }
    
    func setupWelcomeScreen() {
        let directory = "art.scnassets/WelcomeScreen/"
        welcomeScreenView.setup(skScene: skScene, directory: directory, viewBounds: viewBounds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout2DOverlay()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup2DOverlay() {
        let width = viewBounds.width
        let height = viewBounds.height
        
        skScene = SKScene(size: CGSize(width: width, height: height))
        skScene.scaleMode = .resizeFill
        
        skScene.addChild(overlayNode)
        
        overlaySKScene = skScene
        skScene.isUserInteractionEnabled = false
    }
    
    private func layout2DOverlay() {
        overlayNode.position = CGPoint(x: 0.0, y: viewBounds.height)
    }
    
    func removeCurrentView() {
        skScene.removeAllChildren()
    }
}
