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
        
        guard let position4 = enemyPositionArray["werewolf4"] else { return }
        guard let rotation4 = enemyRotationArray["werewolf4"] else { return }
        let wolfModel4 = WerewolfModel(name: "werewolf4", position: position4, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIdle")
        let enemy4 = Enemy(player: player, view: gameView, enemyModel: wolfModel4)
        enemy4.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy4.position = position4
        enemy4.rotation = rotation4
        
        guard let position5 = enemyPositionArray["werewolf5"] else { return }
        guard let rotation5 = enemyRotationArray["werewolf5"] else { return }
        let wolfModel5 = WerewolfModel(name: "werewolf5", position: position5, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIdle")
        let enemy5 = Enemy(player: player, view: gameView, enemyModel: wolfModel5)
        enemy5.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy5.position = position5
        enemy5.rotation = rotation5
        
        guard let position6 = enemyPositionArray["werewolf6"] else { return }
        guard let rotation6 = enemyRotationArray["werewolf6"] else { return }
        let wolfModel6 = WerewolfModel(name: "werewolf6", position: position6, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIdle")
        let enemy6 = Enemy(player: player, view: gameView, enemyModel: wolfModel6)
        enemy6.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy6.position = position6
        enemy6.rotation = rotation6
        
        guard let position7 = enemyPositionArray["werewolf7"] else { return }
        guard let rotation7 = enemyRotationArray["werewolf7"] else { return }
        let wolfModel7 = WerewolfModel(name: "werewolf7", position: position7, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIdle")
        let enemy7 = Enemy(player: player, view: gameView, enemyModel: wolfModel7)
        enemy7.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy7.position = position7
        enemy7.rotation = rotation7
        
        guard let position8 = enemyPositionArray["werewolf8"] else { return }
        guard let rotation8 = enemyRotationArray["werewolf8"] else { return }
        let wolfModel8 = WerewolfModel(name: "werewolf8", position: position8, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIdle")
        let enemy8 = Enemy(player: player, view: gameView, enemyModel: wolfModel8)
        enemy8.scale = SCNVector3Make(enemyScale, enemyScale, enemyScale)
        enemy8.position = position8
        enemy8.rotation = rotation8
        
        //BOSS
        let bossScale: Float = 0.45
        guard let position9 = enemyPositionArray["werewolf9"] else { return }
        guard let rotation9 = enemyRotationArray["werewolf9"] else { return }
        let wolfModel9 = WolfBossModel(name: "werewolf9", position: position9, model: "art.scnassets/Scenes/Characters/Enemies/werewolfIBOSSdle")
        let enemy9 = Enemy(player: player, view: gameView, enemyModel: wolfModel9)
        enemy9.scale = SCNVector3Make(bossScale, bossScale, bossScale)
        enemy9.position = position9
        enemy9.rotation = rotation9
        
        gameView.prepare([enemy1, enemy2, enemy3]) { (finished) in
            self.scene.rootNode.addChildNode(enemy1)
            self.scene.rootNode.addChildNode(enemy2)
            self.scene.rootNode.addChildNode(enemy3)
            self.scene.rootNode.addChildNode(enemy4)
            self.scene.rootNode.addChildNode(enemy5)
            self.scene.rootNode.addChildNode(enemy6)
            self.scene.rootNode.addChildNode(enemy7)
            self.scene.rootNode.addChildNode(enemy8)
            self.scene.rootNode.addChildNode(enemy9)
            
            enemy1.setupCollider(scale: CGFloat(enemyScale))
            enemy2.setupCollider(scale: CGFloat(enemyScale))
            enemy3.setupCollider(scale: CGFloat(enemyScale))
            enemy4.setupCollider(scale: CGFloat(enemyScale))
            enemy5.setupCollider(scale: CGFloat(enemyScale))
            enemy6.setupCollider(scale: CGFloat(enemyScale))
            enemy7.setupCollider(scale: CGFloat(enemyScale))
            enemy8.setupCollider(scale: CGFloat(enemyScale))
            enemy9.setupCollider(scale: CGFloat(bossScale))
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
