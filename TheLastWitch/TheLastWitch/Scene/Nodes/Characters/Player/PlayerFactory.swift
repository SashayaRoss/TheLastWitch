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
    private let model: PlayerModel
    private let mapper: PlayerCharacterMapper
    private var position = SCNVector3(0, 0, 0)
    var scene: SCNScene
    
    //inicjalizacja
    init(
        scene: SCNScene,
        model: PlayerModel,
        mapper: PlayerCharacterMapper
    ) {
        self.scene = scene
        self.model = model
        self.mapper = mapper
        
        if let playerPosition = scene.rootNode.childNode(withName: "Hero", recursively: false) {
            position = playerPosition.position
        }
        
        player = Player(
            playerModel: model,
            mapper: mapper,
            position: position
        )

        setup()
    }
    
    //metoda zwracająca player'a
    func getPlayer() -> Player {
        return player
    }
}

//rozszerzenie klasy o protokół SetupInterface
extension PlayerFactory: SetupInterface {
    func setup() {
        //ustawienie parametrów
        let playerScale = Float(0.2)
        
        player.scale = SCNVector3Make(playerScale, playerScale, playerScale)
        player.position = position
        player.rotation = SCNVector4Make(0, Float.pi, 0, Float.pi)
        
        //dodanie do sceny i ustawienie collider'a
        scene.rootNode.addChildNode(player)
        player.setupCollider(with: CGFloat(playerScale))
    }
}
