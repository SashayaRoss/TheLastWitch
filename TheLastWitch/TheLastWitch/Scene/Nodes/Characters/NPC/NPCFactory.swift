//
//  NPCFactory.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class NPCFactory {
    var scene: SCNScene
    let player: Player
    let gameView: GameView
    
    private var npcPositionArray = [String: SCNVector3]()
    
    init(scene: SCNScene, gameView: GameView, player: Player) {
        self.scene = scene
        self.player = player
        self.gameView = gameView
        
        setup()
    }
    
    private func setupNPC() {
        let npcScale: Float = 0.003
        
        let npc = Npc(player: player, view: gameView)
        npc.scale = SCNVector3Make(npcScale, npcScale, npcScale)
        npc.position = npcPositionArray["npc"]!
        
        gameView.prepare([npc]) { (finished) in
            self.scene.rootNode.addChildNode(npc)
            
            npc.setupCollider(scale: CGFloat(npcScale))
        }
    }
}

extension NPCFactory: SetupInterface {
    func setup() {
        let npcs = scene.rootNode.childNode(withName: "NPC", recursively: false)!
        for child in npcs.childNodes {
            npcPositionArray[child.name!] = child.position
        }
        setupNPC()
    }
}