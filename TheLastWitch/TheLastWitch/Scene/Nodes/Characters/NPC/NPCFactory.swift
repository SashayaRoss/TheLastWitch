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
        let quest = Quest(
            id: 2,
            desc: "Defeat 2 stone golums",
            type: .defeat,
            exp: 50,
            targets: ["golem1", "golem2"]
        )
        let npcModel = VillagerModel(
            dialog: ["1. Hello", "2 Im a villager", "3 life is fun!"],
            quest: quest,
            model: "art.scnassets/Scenes/Characters/Hero/idle"
        )
        let npcModel2 = VillagerModel(
            dialog: ["1. sup mate", "2 Im a cool", "3 life is sdaksjdkasdkajs!"],
            model: "art.scnassets/Scenes/Characters/Hero/idle"
        )
        
        let npcModel3 = VillagerModel(
            dialog: ["1. supdasdasdsmate", "2 Im a codsadasdol", "3 !"],
            model: "art.scnassets/Scenes/Characters/Hero/idle"
        )
        
        let npc = Npc(player: player, view: gameView, npcModel: npcModel2)
        npc.scale = SCNVector3Make(npcScale, npcScale, npcScale)
        npc.position = npcPositionArray["npc"]!
        
        let npc2 = Npc(player: player, view: gameView, npcModel: npcModel)
        npc2.scale = SCNVector3Make(npcScale, npcScale, npcScale)
        npc2.position = npcPositionArray["npc2"]!
        
        let npc3 = Npc(player: player, view: gameView, npcModel: npcModel3)
        npc3.scale = SCNVector3Make(npcScale, npcScale, npcScale)
        npc3.position = npcPositionArray["npc3"]!
        
        gameView.prepare([npc, npc2, npc3]) { (finished) in
            self.scene.rootNode.addChildNode(npc)
            self.scene.rootNode.addChildNode(npc2)
            self.scene.rootNode.addChildNode(npc3)
            
            npc.setupCollider(scale: CGFloat(npcScale))
            npc2.setupCollider(scale: CGFloat(npcScale))
            npc3.setupCollider(scale: CGFloat(npcScale))
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
