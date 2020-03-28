//
//  PlayerFactory.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PlayerFactory {
    var scene: SCNScene
    var player: Player
    
    init(scene: SCNScene) {
        self.scene = scene
        let playerStats = PlayerStatsModel()
        player = Player(playerStats: playerStats)
        setup()
    }
    
    func makePlayer() -> Player {
        return player
    }
}

extension PlayerFactory: SetupInterface {
    func setup() {
        let playerScale = Float(0.003)
        
        player.scale = SCNVector3Make(playerScale, playerScale, playerScale)
        player.position = SCNVector3Make(0.0, 0.0, 0.0)
        player.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        
        scene.rootNode.addChildNode(player)
        player.setupCollider(with: CGFloat(playerScale))
        player.setupWeaponCollider(with: CGFloat(playerScale))
    }
}
