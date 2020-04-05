//
//  HUDScene.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import CoreMotion
import SceneKit
import SpriteKit

final class HUDScene: SKScene {
//    private var gameScene: SCNScene
//    private var gameView: GameView
//    
//    init(gameScene: SCNScene, gameView: GameView) {
//        super.init(size: .zero)
//        self.backgroundColor = .white
//        self.gameScene = gameScene
//        self.gameView = gameView
////        self.ignoresSiblingOrder = true
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    
    
    //MARK: touches + movement
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            if gameView.hudView.dpadNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
//                if padTouch == nil {
//                    padTouch = touch
//                    controllerStoredDirection = float2(0.0)
//                }
//            } else if gameView.hudView.attackButtonNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
//                if let activePlayer = player {
//                    activePlayer.attack()
//                    if activePlayer.playerModel.isInteracting {
//                        activePlayer.walks(walks: false)
//                        gameScene.gameState = .paused
//                        gameScene.currentView = .dialog
//                        gameView.removeCurrentView()
//                        gameView.setupDialog()
//                        activePlayer.npc.dialog()
//                    }
//                }
//            } else if gameView.hudView.optionsButtonNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
//                gameState = .paused
//                gameView.overlaySKScene = OptionsScene(size: UIScreen.main.bounds.size, scene: gameplayScene)
//            } else if gameView.hudView.characterButtonNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
//                gameState = .paused
//                currentView = .character
//                gameView.removeCurrentView()
//                gameView.setupCharacter()
//
//            } else if cameraTouch == nil {
//                cameraTouch = touches.first
//            }
//            if padTouch != nil {
//                break
//            }
//        }
//    }
//

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
    }


//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)

//        if matchedBalls.count >= 5 {
//            let omg = SKSpriteNode(imageNamed: "omg")
//            omg.position = CGPoint(x: frame.midX, y: frame.midY)
//            omg.zPosition = 100
//            omg.xScale = 0.001
//            omg.yScale = 0.001
//            addChild(omg)
//
//            let appear = SKAction.group([SKAction.scale(to: 1, duration: 0.25), SKAction.fadeIn(withDuration: 0.25)])
//            let disappear = SKAction.group([SKAction.scale(to: 2, duration: 0.25), SKAction.fadeOut(withDuration: 0.25)])
//            let sequence = SKAction.sequence([appear, SKAction.wait(forDuration: 0.25), disappear, SKAction.removeFromParent()])
//            omg.run(sequence)
//        }
//    }
}
