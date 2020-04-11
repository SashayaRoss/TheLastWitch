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
        let scale: Float = 0.003
        let shrineModel = MagicShrine(
            dialog: ["I am a wise oracle", "I give knowledge", "And exp", "You have been granted 50 exp by oracle"],
            model: "art.scnassets/Scenes/Characters/Hero/idle",
            perk: .exp
        )
        let shrineModel2 = MagicShrine(
            dialog: ["I give hp", "cool", "You have been granted full hp by oracle"],
            model: "art.scnassets/Scenes/Characters/Hero/idle",
            perk: .fullHP
        )
        
        let magicElements = MagicElements(player: player, view: gameView, magicElementModel: shrineModel)
        magicElements.scale = SCNVector3Make(scale, scale, scale)
        magicElements.position = magicElementsPositionArray["magic1"]!
        
        let magicElements2 = MagicElements(player: player, view: gameView, magicElementModel: shrineModel2)
        magicElements2.scale = SCNVector3Make(scale, scale, scale)
        magicElements2.position = magicElementsPositionArray["magic2"]!
        
        gameView.prepare([magicElements, magicElements2]) { (finished) in
            self.scene.rootNode.addChildNode(magicElements)
            self.scene.rootNode.addChildNode(magicElements2)
            
            magicElements.setupCollider(scale: CGFloat(scale))
            magicElements2.setupCollider(scale: CGFloat(scale))
        }
    }
}

extension MagicElementsFactory: SetupInterface {
    func setup() {
        guard let magic = scene.rootNode.childNode(withName: "Magic", recursively: false) else { return }
        for child in magic.childNodes {
            magicElementsPositionArray[child.name!] = child.position
        }
        setupMagicalElements()
    }
}
