//
//  GameViewController.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 26/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import UIKit
import SceneKit

enum GameState {
    case loading
    case playing
}

class GameViewController: UIViewController {

    var gameView: GameView {
        return view as! GameView
    }
    var mainScene: SCNScene!
    
    var gameState: GameState = .loading
    
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        gameState = .playing
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    //MARK: scene
    private func setupScene() {
        gameView.allowsCameraControl = true
        //possible deletion in case of bad fps performance
        gameView.antialiasingMode = .multisampling4X
        
        mainScene = SCNScene(named: "art.scnassets/Scenes/Stage1.scn")
        gameView.scene = mainScene
        gameView.isPlaying = true
    }
    
    //MARK: walls
    
    //MARK: camera
    
    //MARK: player
    
    //MARK: touches + movement
    
    //MARK: game loop functions
    
    //MARK: enemies

}

//MARK: extensions
