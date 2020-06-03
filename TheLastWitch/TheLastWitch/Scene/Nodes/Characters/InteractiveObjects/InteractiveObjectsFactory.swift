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
    private var interactiveObjectRotationArray = [String: SCNVector4]()
    
    init(scene: SCNScene, gameView: GameView, player: Player) {
        self.scene = scene
        self.player = player
        self.gameView = gameView
        
        setup()
    }
    
    private func setupInteractiveObjects() {
        let scale: Float = 0.3
        let chestModel1 = Chest(
            dialog: ["You have found an old chest.", "You open it.", "Very slowly.", "You are adventurous but you are not a mad man.", "Who knows what horrors you could find there.", "...", "The chest is empty.", "But your courage in touching objects of unknown origin pays off.", "You have learned a valuable lesson today.", "[You receive 50 exp!]"],
            model: "art.scnassets/Scenes/Environment/chest",
            perk: .exp
        )
        let chestModel2 = Chest(
            dialog: ["You see another old chest.", "You open it and find useful herbs inside.", "They make a nice healing potion.", "[You receive full hp!]"],
            model: "art.scnassets/Scenes/Environment/chest",
            perk: .fullHP
        )
        let chestModel3 = Chest(
            dialog: ["Third time's a charm.", "Hidden chest contains a mysterious scroll.", "[You receive extra level points!]", ],
            model: "art.scnassets/Scenes/Environment/chest",
            perk: .points
        )
        
        let interactiveObject1 = Interactive(player: player, view: gameView, interactiveObjectModel: chestModel1)
        interactiveObject1.scale = SCNVector3Make(scale, scale, scale)
        guard let position1 =  interactiveObjectPositionArray["chest1"] else { return }
        guard let rotation1 =  interactiveObjectRotationArray["chest1"] else { return }
        interactiveObject1.position = SCNVector3(position1.x, 0.3, position1.z)
        interactiveObject1.rotation = rotation1
        
        let interactiveObject2 = Interactive(player: player, view: gameView, interactiveObjectModel: chestModel2)
        interactiveObject2.scale = SCNVector3Make(scale, scale, scale)
        guard let position2 =  interactiveObjectPositionArray["chest2"] else { return }
        guard let rotation2 =  interactiveObjectRotationArray["chest2"] else { return }
        interactiveObject2.position = SCNVector3(position2.x, 0.3, position2.z)
        interactiveObject2.rotation = rotation2
        
        let interactiveObject3 = Interactive(player: player, view: gameView, interactiveObjectModel: chestModel3)
        interactiveObject3.scale = SCNVector3Make(scale, scale, scale)
        guard let position3 =  interactiveObjectPositionArray["chest3"] else { return }
        guard let rotation3 =  interactiveObjectRotationArray["chest3"] else { return }
        interactiveObject3.position = SCNVector3(position3.x, 0.3, position3.z)
        interactiveObject3.rotation = rotation3
        
        /// Portal model:
        guard let positionPortal = interactiveObjectPositionArray["portal"] else { return }
        let portalModel = PortalModel(
            dialog: ["You found the portal!",  "Your mission here is done.", "Be careful on your next adventure brave witch!", "[You stepped through the portal]"],
            model: "art.scnassets/Scenes/Environment/portal",
            perk: .fullHP
        )
        let portalScale = Float(1.4)
        let portal = Interactive(player: player, view: gameView, interactiveObjectModel: portalModel)
        portal.scale = SCNVector3Make(scale * portalScale, scale * portalScale, scale * portalScale)
        portal.position = positionPortal
        
        gameView.prepare([interactiveObject1, interactiveObject2]) { (finished) in
            self.scene.rootNode.addChildNode(interactiveObject1)
            self.scene.rootNode.addChildNode(interactiveObject2)
            self.scene.rootNode.addChildNode(interactiveObject3)
            self.scene.rootNode.addChildNode(portal)
            
            interactiveObject1.setupCollider(scale: CGFloat(scale))
            interactiveObject2.setupCollider(scale: CGFloat(scale))
            interactiveObject3.setupCollider(scale: CGFloat(scale))
            portal.setupCollider(scale: CGFloat(scale))
        }
    }
}

extension InteractiveObjectsFactory: SetupInterface {
    func setup() {
        guard let interactive = scene.rootNode.childNode(withName: "Interactive", recursively: false) else { return }
        for child in interactive.childNodes {
            guard let name = child.name else { return }
            interactiveObjectPositionArray[name] = child.position
            interactiveObjectRotationArray[name] = child.rotation
        }
        setupInteractiveObjects()
    }
}
