//
//  MagicElementsFactory.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class MagicElementsFactory {
    var scene: SCNScene
    let player: Player
    let gameView: GameView
    
    private var magicElementsPositionArray = [String: SCNVector3]()
    
    init(scene: SCNScene, gameView: GameView, player: Player) {
        self.scene = scene
        self.player = player
        self.gameView = gameView
        
        setup()
    }
    
    private func setupMagicalElements() {
        let npcScale: Float = 0.003
        let shrine = MagicShrine(dialog: ["1. i am magic", "2 much wow", "3 life sucks!"])
        
        let magicElements = MagicElements(player: player, view: gameView, magicElementModel: shrine)
        magicElements.scale = SCNVector3Make(npcScale, npcScale, npcScale)
        magicElements.position = magicElementsPositionArray["magicalElements"]!
        
        gameView.prepare([magicElements]) { (finished) in
            self.scene.rootNode.addChildNode(magicElements)
            
            magicElements.setupCollider(scale: CGFloat(npcScale))
        }
    }
}

extension MagicElementsFactory: SetupInterface {
    func setup() {
        let npcs = scene.rootNode.childNode(withName: "MagicalElements", recursively: false)!
        for child in npcs.childNodes {
            magicElementsPositionArray[child.name!] = child.position
        }
        setupMagicalElements()
    }
}
