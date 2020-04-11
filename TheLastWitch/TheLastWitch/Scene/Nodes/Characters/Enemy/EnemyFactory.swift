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
        let wolfModel1 = WolfModel(name: "golem1", pathFinder: [])
        let wolfModel2 = WolfModel(name: "golem2", pathFinder: [])
        let wolfModel3 = WolfModel(name: "golem3", pathFinder: [])
        
        let enemy1 = Enemy(player: player, view: gameView, enemyModel: wolfModel1)
        enemy1.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy1.position = enemyPositionArray["golem1"]!
        
        let enemy2 = Enemy(player: player, view: gameView, enemyModel: wolfModel2)
        enemy2.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy2.position = enemyPositionArray["golem2"]!
        
        let enemy3 = Enemy(player: player, view: gameView, enemyModel: wolfModel3)
        enemy3.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy3.position = enemyPositionArray["golem3"]!
        
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
        let enemies = scene.rootNode.childNode(withName: "Enemies", recursively: false)!
        for child in enemies.childNodes {
            enemyPositionArray[child.name!] = child.position
        }
        setupEnemy()
    }
}
