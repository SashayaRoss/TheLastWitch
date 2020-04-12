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
}
