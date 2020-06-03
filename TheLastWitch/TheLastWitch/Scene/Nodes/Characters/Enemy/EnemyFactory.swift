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
    private var enemyRotationArray = [String: SCNVector4]()
    
    init(scene: SCNScene, gameView: GameView, player: Player) {
        self.scene = scene
        self.player = player
        self.gameView = gameView
        
        setup()
    }
    
    private func setupEnemy() {
        let enemyScale: Float = 0.3
        
        guard let position1 = enemyPositionArray["werewolf1"] else { return }
        guard let rotation1 = enemyRotationArray["werewolf1"] else { return }
        let wolfModel1 = WerewolfModel(name: "werewolf1", position: position1, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIdle")
        let enemy1 = Enemy(player: player, view: gameView, enemyModel: wolfModel1)
        enemy1.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy1.position = position1
        enemy1.rotation = rotation1
        
        guard let position2 = enemyPositionArray["werewolf2"] else { return }
        guard let rotation2 = enemyRotationArray["werewolf2"] else { return }
        let wolfModel2 = WerewolfModel(name: "werewolf2", position: position2, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIdle")
        let enemy2 = Enemy(player: player, view: gameView, enemyModel: wolfModel2)
        enemy2.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy2.position = position2
        enemy2.rotation = rotation2
        
        guard let position3 = enemyPositionArray["werewolf3"] else { return }
        guard let rotation3 = enemyRotationArray["werewolf3"] else { return }
        let wolfModel3 = WerewolfModel(name: "werewolf3", position: position3, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIdle")
        let enemy3 = Enemy(player: player, view: gameView, enemyModel: wolfModel3)
        enemy3.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy3.position = position3
        enemy3.rotation = rotation3
        
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
            enemyRotationArray[name] = child.rotation
        }
        setupEnemy()
    }
}
