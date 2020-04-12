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
        let wolfModel1 = WolfModel(name: "golem1")
        let wolfModel2 = WolfModel(name: "golem2")
        let wolfModel3 = WolfModel(name: "golem3")
        
        let enemy1 = Enemy(player: player, view: gameView, enemyModel: wolfModel1)
        enemy1.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        guard let position1 = enemyPositionArray["golem1"] else { return }
        enemy1.position = position1
        enemy1.rotation = SCNVector4(0, 180, 0, 0)
        
        let enemy2 = Enemy(player: player, view: gameView, enemyModel: wolfModel2)
        enemy2.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        guard let position2 = enemyPositionArray["golem2"] else { return }
        enemy2.position = position2
        enemy2.rotation = SCNVector4(0, 90, 0, 0)
        
        let enemy3 = Enemy(player: player, view: gameView, enemyModel: wolfModel3)
        enemy3.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        guard let position3 = enemyPositionArray["golem3"] else { return }
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
    
    func reset() {
        guard
            let enemies = scene.rootNode.childNode(withName: "Enemies", recursively: false)
        else { return }
        for node in enemies.childNodes {
            node.isHidden = false
        }
        setup()
    }
}

extension EnemyFactory: SetupInterface {
    func setup() {
        guard let enemies = scene.rootNode.childNode(withName: "Enemies", recursively: false) else { return }
        for child in enemies.childNodes {
            enemyPositionArray[child.name!] = child.position
        }
        setupEnemy()
    }
}
