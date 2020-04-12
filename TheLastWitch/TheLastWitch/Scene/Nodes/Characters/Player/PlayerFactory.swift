//
//  PlayerFactory.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PlayerFactory {
    private let player: Player
    var scene: SCNScene
    
    init(scene: SCNScene) {
        self.scene = scene
        let playerModel = PlayerModel()
        let mapper = PlayerCharacterMapper()
        
        player = Player(playerModel: playerModel, mapper: mapper)
        setup()
    }
    
    func getPlayer() -> Player {
        return player
    }
}

extension PlayerFactory: SetupInterface {
    func setup() {
        let playerScale = Float(0.003)
        
        player.scale = SCNVector3Make(playerScale, playerScale, playerScale)
        player.position = SCNVector3Make(4, 0.6, -10)
        player.rotation = SCNVector4Make(0, 0, 0, Float.pi)
        
        scene.rootNode.addChildNode(player)
        player.setupCollider(with: CGFloat(playerScale))
    }
}
