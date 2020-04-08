//
//  GameViewController.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 26/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

final class GameViewController: UIViewController {
    var gameView: GameView!
    let gameMusic = MusicManager.sharedInstance
    
    //scene
    var sceneView: SCNView!
    var newGameScene: SCNScene!
    var gameplayScene: SCNScene!
    var transitionScene: SCNScene!
    
    //general
    var gameState: GameState = .newGame
    var currentView: CurrentView = .playing
    
    //nodes
    private var player: Player!
    private var lightStick: SCNNode!
    private var cameraStick: SCNNode!
    
    //movement
    private var controllerStoredDirection = float2(0.0)
    private var padTouch: UITouch?
    private var cameraTouch: UITouch?
    
    //collisions
    private var maxPenetrationDistance = CGFloat(0.0)
    private var replacementPosition = [SCNNode: SCNVector3]()
    
    //setup
    var mainCamera: MainCamera!
    var light: MainLight!
    var collision: Collision!
    var playerFactory: PlayerFactory!
    var enemyFactory: EnemyFactory!
    var npcFactory: NPCFactory!

    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView = view as? GameView
        setupScene()
        setupEnvironment()
        gameState = .playing
    }
    
    //MARK: scene
    private func setupScene() {
        gameplayScene = SceneConfigurator().setup(state: .playing)
        newGameScene = SceneConfigurator().setup(state: .newGame)
        transitionScene = SceneConfigurator().setup(state: .transition)
        
        gameView.antialiasingMode = .multisampling4X
        gameView.delegate = self
        gameView.isUserInteractionEnabled = true

        guard let scene = gameplayScene else { return }
        scene.physicsWorld.contactDelegate = self
        
        gameView.scene = scene
        gameView.isPlaying = true
        
        
        statisticManager(show: true)
    }
    
    private func statisticManager(show: Bool) {
        gameView.showsStatistics = show
    }
    
    private func setupEnvironment() {
        playerFactory = PlayerFactory(scene: gameplayScene)
        player = playerFactory.getPlayer()
        mainCamera = MainCamera(scene: gameplayScene)
        light = MainLight(scene: gameplayScene)
        collision = Collision(scene: gameplayScene)
        enemyFactory = EnemyFactory(scene: gameplayScene, gameView: gameView, player: player)
        npcFactory = NPCFactory(scene: gameplayScene, gameView: gameView, player: player)
        
        lightStick = light.setup()
        cameraStick = mainCamera.setup()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    //MARK: touches + movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch currentView {
        case .tapToPlay:
            presentGame()
        case .playing:
            gameState = .playing
            gameplayAction(touches: touches)
        case .options:
            print("nope")
//            optionsAction(touches: touches)
        case .dialog:
            dialogAction(touches: touches)
        case .character:
            characterMenu(touches: touches)
        }
    }
    
    private func gameplayAction(touches: Set<UITouch>) {
        for touch in touches {
            if gameView.hudView.dpadNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
                if padTouch == nil {
                    padTouch = touch
                    controllerStoredDirection = float2(0.0)
                }
            } else if gameView.hudView.attackButtonNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
                if let activePlayer = player {
                    activePlayer.attack()
                    if activePlayer.playerModel.isInteracting {
                        activePlayer.walks(walks: false)
                        gameState = .paused
                        currentView = .dialog
                        gameView.removeCurrentView()
                        gameView.setupDialog()
                        dialogAction(touches: touches)
                    }
                }
            } else if gameView.hudView.optionsButtonNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
//                testPresent()
                presentWelcomeScreen()
            } else if gameView.hudView.characterButtonNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
                gameState = .paused
                currentView = .character
                gameView.removeCurrentView()
                gameView.setupCharacter()
                player.updateCharacterModelData()
                
            } else if cameraTouch == nil {
                cameraTouch = touches.first
            }
            if padTouch != nil {
                break
            }
        }
    }
    
    private func dialogAction(touches: Set<UITouch>) {
        for touch in touches {
            if gameView.dialogView.dialogBoxNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
                //update text and quit
                if let activePlayer = player {
                    if (activePlayer.npc.currentDialog < activePlayer.npc.npcModel.dialog.count) {
                        activePlayer.npc.dialog()
                    } else {
                        activePlayer.npc.currentDialog = 0
                        if
                            let quest = activePlayer.npc.npcModel.quest,
                            //TODO change desc to quest
                            !activePlayer.playerModel.activeQuests.contains(quest.desc)
                        {
                            activePlayer.playerModel.activeQuests.append(quest.desc)
                        }
                        gameView.removeCurrentView()
                        currentView = .playing
                        gameState = .playing
                        gameView.setupHUD()
                        activePlayer.updateModelData()
                    }
                }
            }
        }
    }
    
    private func characterMenu(touches: Set<UITouch>) {
        for touch in touches {
            //go back
            if gameView.characterView.goBack.virtualNodeBounds().contains(touch.location(in: gameView)) {
                gameView.removeCurrentView()
                currentView = .playing
                gameView.setupHUD()
                if let activePlayer = player {
                    activePlayer.updateModelData()
                }
            } else if gameView.characterView.health.virtualNodeBounds().contains(touch.location(in: gameView)) {
                if let activePlayer = player {
                    activePlayer.updateHealth()
                }
                print("ADD HEALTH")
            } else if gameView.characterView.magic.virtualNodeBounds().contains(touch.location(in: gameView)) {
                if let activePlayer = player {
                    activePlayer.updateMagic()
                }
                print("ADD MAGIC")
            } else if gameView.characterView.speed.virtualNodeBounds().contains(touch.location(in: gameView)) {
                if let activePlayer = player {
                    activePlayer.updateSpeed()
                }
                print("ADD SPEED")
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = padTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))

            let vMix = mix(controllerStoredDirection, displacement, t: 0.1)
            let vClamp = clamp(vMix, min: -1.0, max: 1.0)

            controllerStoredDirection = vClamp
            
            player.dPadOrigin = gameView.hudView.dpadNode.virtualNodeBounds().origin
            player.touchLocation = touch.location(in: self.view)
            player.cameraRotation = mainCamera.getRotation()
        } else if let touch = cameraTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))
            mainCamera.panCamera(displacement)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        padTouch = nil
        cameraTouch = nil
        controllerStoredDirection = float2(0.0)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        padTouch = nil
        cameraTouch = nil
        controllerStoredDirection = float2(0.0)
    }

    private func playerDirection() -> float3 {
        var direction = float3(controllerStoredDirection.x, 0.0, controllerStoredDirection.y)

        if let pov = gameView.pointOfView {
            let p1 = pov.presentation.convertPosition(SCNVector3(direction), to: nil)
            let p0 = pov.presentation.convertPosition(SCNVector3Zero, to: nil)

            direction = float3(Float(p1.x - p0.x), 0.0, Float(p1.z - p0.z))

            if direction.x != 0.0 || direction.z != 0.0 {
                direction = normalize(direction)
            }
        }
        return direction
    }
    
    private func characterNode(_ characterNode: SCNNode, hitWall wall: SCNNode, withContact contact: SCNPhysicsContact) {
        if characterNode.name != "collider" && characterNode.name != "enemyCollider" { return }
        if maxPenetrationDistance > contact.penetrationDistance { return }
        maxPenetrationDistance = contact.penetrationDistance
        
        var characterPosition = float3(characterNode.parent!.position)
        var positionOffset = float3(contact.contactNormal) * Float(contact.penetrationDistance)
        positionOffset.y = 0
        characterPosition += positionOffset
        
        replacementPosition[characterNode.parent!] = SCNVector3(characterPosition)
    }
    
    //MARK: game loop functions
    private func updateFollowersPosition() {
        guard
            let character = player
        else {
            return
        }
        cameraStick.position = SCNVector3Make(character.position.x, 0.0, character.position.z)
        lightStick.position = SCNVector3Make(character.position.x, 0.0, character.position.z)
    }
    
    
//    func testPresent() {
//        gameView.isUserInteractionEnabled = false
//        gameplayScene.isPaused = true
//        let transition = SKTransition.fade(withDuration: 1.8)
//        currentView = .tapToPlay
//
//        gameView.present(transitionScene, with: transition, incomingPointOfView: nil, completionHandler: {
//            self.gameState = .transition
//            self.transitionScene.isPaused = false
//
//            DispatchQueue.main.async {
//                self.gameView.removeCurrentView()
//                self.presentWelcomeScreen()
//            }
//        })
//    }
    
    //changing scenes
    func presentWelcomeScreen() {
        gameView.isUserInteractionEnabled = false
        gameplayScene.isPaused = true
        let transition = SKTransition.fade(withDuration: 1.8)
        currentView = .tapToPlay
        
        gameView.present(newGameScene, with: transition, incomingPointOfView: nil, completionHandler: {
            self.gameState = .newGame
            self.newGameScene.isPaused = false
            self.gameView.removeCurrentView()
            self.gameView.setupWelcomeScreen()
            DispatchQueue.main.async {
                self.gameView.isUserInteractionEnabled = true
            }
        })
    }
    
    func presentGame() {
        NotificationCenter.default.post(name: NSNotification.Name("stopVideo"), object: nil)
        gameView.isUserInteractionEnabled = false
        newGameScene.isPaused = true
        let transition = SKTransition.fade(withDuration: 1.8)
        currentView = .playing
        
        gameView.present(gameplayScene, with: transition, incomingPointOfView: nil, completionHandler: {
            self.gameState = .playing
            self.gameplayScene.isPaused = false
            self.gameView.removeCurrentView()
            self.gameView.setupHUD()
            DispatchQueue.main.async {
                self.gameView.isUserInteractionEnabled = true
            }
        })
    }
}

// MARK: delegates
extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        if gameState != .playing { return }
        
        for (node, position) in replacementPosition {
            node.position = position
        }
        if player.playerModel.isDead {
            presentWelcomeScreen()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gameState != .playing { return }
        
        //reset
        replacementPosition.removeAll()
        maxPenetrationDistance = 0.0
        
        let scene = gameView.scene!
        let direction = playerDirection()
        player!.walkInDirection(direction, time: time, scene: scene)
        
        updateFollowersPosition()
        
        //enemy & npc
        gameplayScene.rootNode.enumerateChildNodes { (node, _) in
            if let name = node.name {
                switch name {
                case "Enemy":
                    (node as! Enemy).update(with: time, and: scene)
                case "Npc":
                    (node as! Npc).update(with: time, and: scene)
                case "MagicElement":
                    (node as! MagicElements).update(with: time, and: scene)
                default:
                    break
                }
            }
        }
    }
}

extension GameViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if gameState != .playing { return }
        //if player collide with wall
        contact.match(Bitmask().wall) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
        
        // if player collides with enemy
        contact.match(Bitmask().enemy) { (matching, other) in
            let enemy = matching.parent as! Enemy
            if other.name == "collider" { enemy.isCollidingWithPlayer = true }
            if other.name == "weaponCollider" { player!.weaponCollide(with: enemy) }
        }
        
        //if player collides with npc
        contact.match(Bitmask().npc) { (matching, other) in
            let npc = matching.parent as! Npc
            if other.name == "collider" { npc.isCollidingWithPlayer = true }
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
        
        //if player collides with magical object
        contact.match(Bitmask().magicElement) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        //if player collide with wall
        contact.match(Bitmask().wall) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
        
        // if player collides with enemy
        contact.match(Bitmask().enemy) { (matching, other) in
            let enemy = matching.parent as! Enemy
            if other.name == "collider" { enemy.isCollidingWithPlayer = true }
            if other.name == "weaponCollider" { player!.weaponCollide(with: enemy) }
        }
        
        //if player collides with npc
        contact.match(Bitmask().npc) { (matching, other) in
            let npc = matching.parent as! Npc
            if other.name == "collider" { npc.isCollidingWithPlayer = true }
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
        
        //if player collides with magical object
        contact.match(Bitmask().magicElement) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        // if player collides with enemy
        contact.match(Bitmask().enemy) { (matching, other) in
            let enemy = matching.parent as! Enemy
            if other.name == "collider" { enemy.isCollidingWithPlayer = false }
            if other.name == "weaponCollider" { player!.weaponUnCollide(with: enemy) }
        }
        //if player collides with npc
        contact.match(Bitmask().npc) { (matching, other) in
            let npc = matching.parent as! Npc
            if other.name == "collider" { npc.isCollidingWithPlayer = true }
        }
        
        //if player collides with magical object
        contact.match(Bitmask().magicElement) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }
}
