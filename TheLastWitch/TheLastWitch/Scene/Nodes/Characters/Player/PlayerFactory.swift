//
//  PlayerFactory.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PlayerFactory {
    private var player: Player
    var scene: SCNScene
    
    init(scene: SCNScene) {
        self.scene = scene
        //todo: init
        let playerModel = PlayerModel()
        let mapper = PlayerCharacterMapper()
        
        player = Player(playerModel: playerModel, mapper: mapper)
        setup()
    }
    
    func getPlayer() -> Player {
        return player
    }
    
    func reset() {
        player.position = SCNVector3Make(4, 0.6, -10)
        player.rotation = SCNVector4Make(0, 0, 0, Float.pi)
        
        player.playerModel.resetModel()
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
