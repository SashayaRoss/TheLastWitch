//
//  InteractiveObjectsFactory.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class InteractiveObjectsFactory {
    var scene: SCNScene
    let player: Player
    let gameView: GameView
    
    private var interactiveObjectPositionArray = [String: SCNVector3]()
    
    init(scene: SCNScene, gameView: GameView, player: Player) {
        self.scene = scene
        self.player = player
        self.gameView = gameView
        
        setup()
    }
    
    private func setupInteractiveObjects() {
        let scale: Float = 0.005
        let chestModel1 = Chest(
            dialog: ["I am a magic well", "I know I don't look like one yet", "I can give you some exp", "You have been granted 50 exp!"],
            model: "art.scnassets/Scenes/Characters/Hero/idle",
            perk: .exp
        )
        let chestModel2 = Chest(
            dialog: ["I am a maical shrine.", "I can restore your hp", "You have been granted full hp"],
            model: "art.scnassets/Scenes/Characters/Hero/idle",
            perk: .fullHP
        )
        
        let interactiveObject1 = InteractiveObject(player: player, view: gameView, interactiveObjectModel: chestModel1)
        interactiveObject1.scale = SCNVector3Make(scale, scale, scale)
        guard let position1 =  interactiveObjectPositionArray["magic1"] else { return }
        interactiveObject1.position = position1
        
        let interactiveObject2 = InteractiveObject(player: player, view: gameView, interactiveObjectModel: chestModel2)
        interactiveObject2.scale = SCNVector3Make(scale, scale, scale)
        guard let position2 =  interactiveObjectPositionArray["magic2"] else { return }
        interactiveObject2.position = position2
        
        /// Portal model:
        guard let positionPortal = interactiveObjectPositionArray["portal"] else { return }
        let portalModel = PortalModel(
            dialog: ["You found the portal!",  "Your mission here is done.", "Be careful on your next adventure brave witch!", "[You stepped through the portal]"],
            model: "art.scnassets/Scenes/Enviroment/portal",
            perk: .fullHP
        )
        let portal = InteractiveObject(player: player, view: gameView, interactiveObjectModel: portalModel)
        portal.scale = SCNVector3Make(scale, scale, scale)
        portal.position = positionPortal
        
        gameView.prepare([interactiveObject1, interactiveObject2]) { (finished) in
            self.scene.rootNode.addChildNode(interactiveObject1)
            self.scene.rootNode.addChildNode(interactiveObject2)
            self.scene.rootNode.addChildNode(portal)
            
            interactiveObject1.setupCollider(scale: CGFloat(scale))
            interactiveObject2.setupCollider(scale: CGFloat(scale))
            portal.setupCollider(scale: CGFloat(scale))
        }
    }
}

extension InteractiveObjectsFactory: SetupInterface {
    func setup() {
        guard let magic = scene.rootNode.childNode(withName: "Magic", recursively: false) else { return }
        for child in magic.childNodes {
            guard let name = child.name else { return }
            interactiveObjectPositionArray[name] = child.position
        }
        setupInteractiveObjects()
    }
}
