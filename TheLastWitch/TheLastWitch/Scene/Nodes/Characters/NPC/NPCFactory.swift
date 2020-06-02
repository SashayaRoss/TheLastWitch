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
    private var npcRotationArray = [String: SCNVector4]()
    
    init(scene: SCNScene, gameView: GameView, player: Player) {
        self.scene = scene
        self.player = player
        self.gameView = gameView
        
        setup()
    }
    
    private func setupNPC() {
        // ustawienie parametrów i modeli dla npc
        let npcScale = Float(0.25)
        let quest = Quest(
            id: 1,
            desc: "Defeat 2 monsters in nearby forest. You will recive 50 exp!",
            type: .defeat,
            exp: 50,
            targets: [.werewolf, .werewolf]
        )
        let npcModel1 = VillagerModel(
            dialog: ["Hello", "I'm a villager", "I live here and I have a task for you! We are in desperate need of a hero! almost there", "almost there asdasd ashdi asud as dasidjasd asudas iuhdi asuh diash diu ashda dasiodas das das dasoifj saoid asdoijsa doijas daosd aosdja sdasd almost there", "almost there asdasd ashdi asud as dasidjasd asudas iuhdi asuh diash diu ashda dasiodas das das dasoifj saoid asdoijsa doijas daosd aosdja sdasd"],
            quest: quest,
            model: "art.scnassets/Scenes/Characters/Vilagers/femaleVilagerIdle"
        )
        let npcModel2 = VillagerModel(
            dialog: ["Hi!", "I'm not from arouond here", "Sory, no quest from me"],
            model: "art.scnassets/Scenes/Characters/Vilagers/femaleVilagerIdle2"
        )
        let npcModel3 = VillagerModel(
            dialog: ["Hi3!", "almost there", "almost there asdasd ashdi asud as dasidjasd asudas iuhdi asuh diash diu ashda dasiodas das das dasoifj saoid asdoijsa doijas daosd aosdja sdasd almost there", "almost there asdasd ashdi asud as dasidjasd asudas iuhdi asuh diash diu ashda dasiodas das das dasoifj saoid asdoijsa doijas daosd aosdja sdasd"],
            model: "art.scnassets/Scenes/Characters/Vilagers/femaleVilagerIdle"
        )
        
        let npc1 = Npc(player: player, view: gameView, npcModel: npcModel1)
        npc1.scale = SCNVector3Make(npcScale, npcScale, npcScale)
        guard let position = npcPositionArray["npc1"] else { return }
        guard let rotation1 = npcRotationArray["npc1"] else { return }
        npc1.position = position
        npc1.rotation = rotation1
        
        let npc2 = Npc(player: player, view: gameView, npcModel: npcModel2)
        npc2.scale = SCNVector3Make(npcScale, npcScale, npcScale)
        guard let position2 = npcPositionArray["npc2"] else { return }
        guard let rotation2 = npcRotationArray["npc2"] else { return }
        npc2.position = position2
        npc2.rotation = rotation2
        
        let npc3 = Npc(player: player, view: gameView, npcModel: npcModel3)
        npc3.scale = SCNVector3Make(npcScale, npcScale, npcScale)
        guard let position3 = npcPositionArray["npc3"] else { return }
        guard let rotation3 = npcRotationArray["npc3"] else { return }
        npc3.position = position3
        npc3.rotation = rotation3
        
        //dodanie modeli do sceny i ustawienie ich collider'ów
        gameView.prepare([npc1, npc2]) { (finished) in
            self.scene.rootNode.addChildNode(npc1)
            self.scene.rootNode.addChildNode(npc2)
            self.scene.rootNode.addChildNode(npc3)
            
            npc1.setupCollider(scale: CGFloat(npcScale))
            npc2.setupCollider(scale: CGFloat(npcScale))
            npc3.setupCollider(scale: CGFloat(npcScale))
        }
    }
}

extension NPCFactory: SetupInterface {
    func setup() {
        guard let npcs = scene.rootNode.childNode(withName: "NPC", recursively: false) else { return }
        for child in npcs.childNodes {
            guard let name = child.name else { return }
            npcPositionArray[name] = child.position
            npcRotationArray[name] = child.rotation
        }
        setupNPC()
    }
}
