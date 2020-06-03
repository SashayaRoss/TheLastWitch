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
        let quest1 = Quest(
            id: 1,
            desc: "Defeat 3 werewolves in the nearby forest. [Reward: 100 exp]",
            type: .defeat,
            exp: 100,
            targets: [.werewolf, .werewolf, .werewolf]
        )
        let quest2 = Quest(
            id: 2,
            desc: "Defeat pack leader. [Reward: 200 exp]",
            type: .defeat,
            exp: 20,
            targets: [.boss]
        )
        let npcModel1 = VillagerModel(
            dialog: ["Hello", "I don't recognise you. You must be new here. Aren't you a little too young to be wandering on your own here?", "What?! A witch?!", "We haven't seen a witch in these parts of the mountains for quite some time.", "And we could certainly use one now...", "You see someone brought a terrible curse upon our forest. It attracts all the werewolves from the far mountains to our lands.", "They steal our food and attack anyone who dares to take the path to the northern travel portal.", "Since it seems like you are going that way, could you try to scare them off?", "Please help us!"],
            quest: quest1,
            model: "art.scnassets/Scenes/Characters/Vilagers/femaleVilagerIdle"
        )
        let npcModel2 = VillagerModel(
            dialog: ["Oh my! Oh my!", "I saw you fight these beasts!", "Thank you so much for saving me.", "I went into the woods looking for some mushrooms for a stew. But when I tried to go back to my village these monsters were right on the main path", "I couldn't go around, the mountains were to high too climb!", "thank you young witch. Now I can safely return home."],
            model: "art.scnassets/Scenes/Characters/Vilagers/femaleVilagerIdle2"
        )
        let npcModel3 = VillagerModel(
            dialog: ["Hi there!", "You say you saw two people looking exactly like me?", "Why of course this haircut is really in this season.", "Why there aren't any men in the village?", "They gathered all the bows and went deep into the woods to hunt for the werewolves and the druid that cursed us.", "Looks like you are doing way better job at fighting these things then they do.", "Why don't we make a deal?", "You defeat the pack leader for me, and I'm sure it will help with your combat experience."],
            quest: quest2,
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
