//
//  EnemyFactory.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class EnemyFactory {
    var scene: SCNScene
    let player: Player
    let gameView: GameView
    
    private var enemyPositionArray = [String: SCNVector3]()
    
    init(scene: SCNScene, gameView: GameView, player: Player) {
        self.scene = scene
        self.player = player
        self.gameView = gameView
        
        setup()
    }
    
    private func setupEnemy() {
        let enemyScale: Float = 0.0080
        
        guard let position1 = enemyPositionArray["golem1"] else { return }
        let wolfModel1 = WolfModel(name: "golem1", position: position1)
        let enemy1 = Enemy(player: player, view: gameView, enemyModel: wolfModel1)
        enemy1.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy1.position = position1
        enemy1.rotation = SCNVector4(0, 180, 0, 0)
        
        guard let position2 = enemyPositionArray["golem2"] else { return }
        let wolfModel2 = WolfModel(name: "golem2", position: position2)
        let enemy2 = Enemy(player: player, view: gameView, enemyModel: wolfModel2)
        enemy2.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy2.position = position2
        enemy2.rotation = SCNVector4(0, 90, 0, 0)
        
        guard let position3 = enemyPositionArray["golem3"] else { return }
        let wolfModel3 = WolfModel(name: "golem3", position: position3)
        let enemy3 = Enemy(player: player, view: gameView, enemyModel: wolfModel3)
        enemy3.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy3.position = position3
        enemy3.rotation = SCNVector4(0, 0, 0, 0)
        
        gameView.prepare([enemy1, enemy2, enemy3]) { (finished) in
            self.scene.rootNode.addChildNode(enemy1)
            self.scene.rootNode.addChildNode(enemy2)
            self.scene.rootNode.addChildNode(enemy3)
            
            enemy1.setupCollider(scale: CGFloat(enemyScale))
            enemy2.setupCollider(scale: CGFloat(enemyScale))
            enemy3.setupCollider(scale: CGFloat(enemyScale))
        }
    }
    
}

extension EnemyFactory: SetupInterface {
    func setup() {
        guard
            let enemies = scene.rootNode.childNode(withName: "Enemies", recursively: false)
        else { return }
        for child in enemies.childNodes {
            guard let name = child.name else { return }
            enemyPositionArray[name] = child.position
        }
        setupEnemy()
    }
}
