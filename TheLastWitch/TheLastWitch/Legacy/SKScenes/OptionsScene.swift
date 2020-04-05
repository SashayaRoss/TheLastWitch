//
//  OptionsScene.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 04/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import CoreMotion
import SceneKit
import SpriteKit

final class OptionsScene: SKScene {
    var pauseNode: SKSpriteNode!
    var scoreNode: SKLabelNode!
    
    init(size: CGSize, scene: SCNScene) {
        super.init(size: size)
//        = UIImage(named: "art.scnassets/UI/Options/dialog2.png")
        self.backgroundColor = .white
        
        
//        self.ignoresSiblingOrder = true
        
        
        let spriteSize = size.width/12
        self.pauseNode = SKSpriteNode(imageNamed: "Pause Button")
        self.pauseNode.size = CGSize(width: spriteSize, height: spriteSize)
        self.pauseNode.position = CGPoint(x: spriteSize + 8, y: spriteSize + 8)
        
        self.scoreNode = SKLabelNode(text: "Score: 0")
        self.scoreNode.fontName = "DINAlternate-Bold"
        self.scoreNode.fontColor = UIColor.black
        self.scoreNode.fontSize = 24
        self.scoreNode.position = CGPoint(x: size.width/2, y: self.pauseNode.position.y - 9)
        
        self.addChild(self.pauseNode)
        self.addChild(self.scoreNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        
        if pauseNode.contains(location) {
            if !isPaused {
                pauseNode.texture = SKTexture(imageNamed: "Play Button")
            } else {
                pauseNode.texture = SKTexture(imageNamed: "Pause Button")
            }
            
            isPaused = !isPaused
        }
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
