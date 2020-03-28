//
//  SceneTwo.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

class SceneTwo: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.green
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sceneOne = SceneOne(fileNamed: "art.scnassets/Scenes/Stage1.scn")
        sceneOne?.scaleMode = .aspectFill
        self.view?.presentScene(sceneOne)
    }
}
