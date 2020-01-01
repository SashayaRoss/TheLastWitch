//
//  GameViewController.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 26/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    var gameView: GameView {
        return view as! GameView
    }
    
    var sceneView: SCNView!
    var mainScene: SCNScene!
    
    //general
    var gameState: GameState = .loading
    
    //nodes
    private var player: Player?
    var motionForce = SCNVector3(x: 0, y: 0, z: 0)
    
    //movement
    private var controllerStoredDirection = float2(0.0)
    private var padTouch: UITouch?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupPlayer()
        
        gameState = .playing
    }
    
    //MARK: scene
    private func setupScene() {
        gameView.antialiasingMode = .multisampling4X
        gameView.delegate = self
        gameView.isUserInteractionEnabled = true

        mainScene = SCNScene(named: "art.scnassets/Scenes/Stage1.scn")
        gameView.scene = mainScene
        gameView.isPlaying = true
    }
    
    override var shouldAutorotate: Bool {
        return false
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
    
    //MARK: player
    private func setupPlayer() {
        player = Player(animation: PlayerAnimation())
        player!.scale = SCNVector3Make(0.0026, 0.0026, 0.0026)
        player!.position = SCNVector3Make(0.0, 0.0, 0.0)
        player!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        
        mainScene.rootNode.addChildNode(player!)
    }
    
    //MARK: touches + movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print("touch:")
            print(touch.location(in: gameView))
            if gameView.dpadNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
                if padTouch == nil {
                    padTouch = touch
                    controllerStoredDirection = float2(0.0)
                }
            }
            if padTouch != nil {
                break
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = padTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))

            let vMix = mix(controllerStoredDirection, displacement, t: 0.1)
            let vClamp = clamp(vMix, min: -1.0, max: 1.0)

            controllerStoredDirection = vClamp
            print(controllerStoredDirection)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        padTouch = nil
        controllerStoredDirection = float2(0.0)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        padTouch = nil
        controllerStoredDirection = float2(0.0)
    }

    private func playerDirection() -> float3 {
        var direction = float3(controllerStoredDirection.x, 0.0, controllerStoredDirection.y)

        if let pov = gameView.pointOfView {
            let p1 = pov.presentation.convertPosition(SCNVector3(direction), to: nil)
            let p0 = pov.presentation.convertPosition(SCNVector3Zero, to: nil)

            direction = float3(Float(p1.x - p0.x), 0.0, Float(p1.z - p0.z))

            if direction.x != 0.0 || direction.z != 0.0 {
                direction = normalize(direction)
            }
        }
        return direction
    }
    
    //MARK: walls
    
    //MARK: camera
    
    //MARK: game loop functions
    
    //MARK: enemies

}

//MARK: extensions
extension float2 {
    init(_ v: CGPoint) {
        self.init(Float(v.x), Float(v.y))
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gameState != .playing { return }
        
        let scene = gameView.scene!
        let direction = playerDirection()
        player!.walkInDirection(direction, time: time, scene: scene)
    }
}
