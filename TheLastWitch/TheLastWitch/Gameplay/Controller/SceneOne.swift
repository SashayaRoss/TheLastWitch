//
//  SceneOne.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

class SceneOne: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.blue
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sceneTwo = SceneTwo(fileNamed: "SceneTwo")
        sceneTwo?.scaleMode = .aspectFill
        self.view?.presentScene(sceneTwo!, transition: SKTransition.fade(withDuration: 0.5))
    }
}
