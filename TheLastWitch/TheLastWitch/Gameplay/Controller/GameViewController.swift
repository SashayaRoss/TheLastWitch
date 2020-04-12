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
    private var showStatistic: Bool = false
    
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
    var magicFactory: MagicElementsFactory!

    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView = view as? GameView
        setupScene()
        setupObservers()
        gameState = .playing
        
        //TODO
//        presentWelcomeScreen()
    }
    
    //MARK: scene
    private func setupScene() {
        gameplayScene = SceneConfigurator().setup(state: .playing)
        newGameScene = SceneConfigurator().setup(state: .newGame)
        transitionScene = SceneConfigurator().setup(state: .transition)
        
        guard let view = gameView else { return }
        view.antialiasingMode = .multisampling4X
        view.delegate = self
        view.isUserInteractionEnabled = true

        guard let scene = gameplayScene else { return }
        scene.physicsWorld.contactDelegate = self
        
//        guard let welcomeScene = newGameScene else { return }
//        view.scene = welcomeScene
        
        //TODO: remove
        view.scene = scene
        
        view.isPlaying = true
        setupEnvironment(with: scene)
    }
    
    private func setupEnvironment(with scene: SCNScene) {
        guard let view = gameView else { return }
        let model = PlayerModel()
        let mapper = PlayerCharacterMapper()
        
        playerFactory = PlayerFactory(scene: scene, model: model, mapper: mapper)
        player = playerFactory.getPlayer()
        mainCamera = MainCamera(scene: scene)
        light = MainLight(scene: scene)
        collision = Collision(scene: scene)
        enemyFactory = EnemyFactory(scene: scene, gameView: view, player: player)
        npcFactory = NPCFactory(scene: scene, gameView: view, player: player)
        magicFactory = MagicElementsFactory(scene: scene, gameView: view, player: player)
        
        lightStick = light.setup()
        cameraStick = mainCamera.setup()
        
        gameMusic.loadSounds()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(gameOver), name: NSNotification.Name("resetGame"), object: nil)
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
            optionsAction(touches: touches)
        case .dialog:
            dialogAction(touches: touches)
        case .character:
            characterMenuAction(touches: touches)
        case .gameOver:
            gameOverAction(touches: touches)
        }
    }
    
    private func gameplayAction(touches: Set<UITouch>) {
        guard let view = gameView else { return }
        for touch in touches {
            if view.hudView.dpadNode.virtualNodeBounds().contains(touch.location(in: view)) {
                if padTouch == nil {
                    padTouch = touch
                    controllerStoredDirection = float2(0.0)
                }
            } else if view.hudView.attackButtonNode.virtualNodeBounds().contains(touch.location(in: view)) {
                if let activePlayer = player {
                    if let npc = activePlayer.npc, npc.isInteracting {
                        player.playerModel.isInteracting = true
                        player.playerModel.currentInteraction = .npc
                    }
                    if let magic = activePlayer.magic, magic.isInteracting {
                        player.playerModel.isInteracting = true
                        player.playerModel.currentInteraction = .magic
                    }
                    
                    if player.playerModel.isInteracting {
                        activePlayer.walks(walks: false)
                        gameState = .paused
                        currentView = .dialog
                        player.questManager()
                        view.removeCurrentView()
                        view.setupDialog()
                        dialogAction(touches: touches)
                    } else {
                        activePlayer.attack()
                        gameMusic.playSound(node: activePlayer, name: "Magic")
                    }
                }
            } else if view.hudView.optionsButtonNode.virtualNodeBounds().contains(touch.location(in: view)) {
                gameState = .paused
                currentView = .options
                view.removeCurrentView()
                view.setupOptions()
                
            } else if view.hudView.characterButtonNode.virtualNodeBounds().contains(touch.location(in: view)) {
                gameState = .paused
                currentView = .character
                view.removeCurrentView()
                view.setupCharacter()
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
        guard let view = gameView else { return }
        for touch in touches {
            if view.dialogView.dialogBoxNode.virtualNodeBounds().contains(touch.location(in: view)) {
                
                if let activePlayer = player {
                    switch activePlayer.playerModel.currentInteraction {
                    //talk with npc
                    case .npc:
                        if
                            let npc = activePlayer.npc,
                            (npc.currentDialog < npc.npcModel.dialog.count)
                        {
                            npc.dialog()
                        } else {
                            if let npc = activePlayer.npc {
                                npc.currentDialog = 0
                            }
                            view.removeCurrentView()
                            currentView = .playing
                            gameState = .playing
                            view.setupHUD()
                            activePlayer.updateModelData()
                            activePlayer.playerModel.currentInteraction = .none
                        }
                    //interact with magic
                    case .magic:
                        if
                            let magic = activePlayer.magic,
                            (magic.currentDialog < magic.magicElementModel.dialog.count)
                        {
                            magic.dialog()
                        } else {
                            if let magic = activePlayer.magic {
                               magic.currentDialog = 0
                            }
                            activePlayer.magic?.perkPlayer()
                            view.removeCurrentView()
                            currentView = .playing
                            gameState = .playing
                            view.setupHUD()
                            activePlayer.updateModelData()
                            activePlayer.playerModel.currentInteraction = .none
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func characterMenuAction(touches: Set<UITouch>) {
        guard let view = gameView else { return }
        for touch in touches {
            if view.characterView.goBack.virtualNodeBounds().contains(touch.location(in: view)) {
                view.removeCurrentView()
                currentView = .playing
                view.setupHUD()
                if let activePlayer = player {
                    activePlayer.updateModelData()
                }
            } else if
                view.characterView.health.virtualNodeBounds().contains(touch.location(in: view)),
                player.playerModel.levelPoints >= 1
            {
                if let activePlayer = player {
                    activePlayer.updateHealth()
                }
            } else if
                view.characterView.magic.virtualNodeBounds().contains(touch.location(in: view)),
                player.playerModel.levelPoints >= 1
            {
                if let activePlayer = player {
                    activePlayer.updateMagic()
                }
            } else if
                view.characterView.speed.virtualNodeBounds().contains(touch.location(in: view)),
                player.playerModel.levelPoints >= 1
            {
                if let activePlayer = player {
                    activePlayer.updateSpeed()
                }
            }
        }
    }
    
    private func optionsAction(touches: Set<UITouch>) {
        guard let view = gameView else { return }
        for touch in touches {
            if view.optionsView.goBack.virtualNodeBounds().contains(touch.location(in: view)) {
                view.removeCurrentView()
                currentView = .playing
                view.setupHUD()
                if let activePlayer = player {
                    activePlayer.updateModelData()
                }
            } else if
                view.optionsView.newGame.virtualNodeBounds().contains(touch.location(in: view))
            {
                presentWelcomeScreen()
            } else if
                view.optionsView.devMode.virtualNodeBounds().contains(touch.location(in: view))
            {
                statisticManager()
            }
            else if
                view.optionsView.music.virtualNodeBounds().contains(touch.location(in: view))
            {
                if gameplayScene.rootNode.audioPlayers == [] {
                    gameMusic.playTheme(scene: gameplayScene, directory: "art.scnassets/Audio/Music.mp3")
                } else {
                    gameMusic.removeAllPlayers(scene: gameplayScene)
                }
            }
        }
    }
    
    private func gameOverAction(touches: Set<UITouch>) {
        for touch in touches {
            presentWelcomeScreen()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = gameView else { return }
        guard let somePlayer = player else { return }
        
        if let touch = padTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))

            let vMix = mix(controllerStoredDirection, displacement, t: 0.1)
            let vClamp = clamp(vMix, min: -1.0, max: 1.0)

            controllerStoredDirection = vClamp
            
            somePlayer.dPadOrigin = view.hudView.dpadNode.virtualNodeBounds().origin
            somePlayer.touchLocation = touch.location(in: self.view)
            somePlayer.cameraRotation = mainCamera.getRotation()
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
        guard let view = gameView else { return float3() }
        var direction = float3(controllerStoredDirection.x, 0.0, controllerStoredDirection.y)

        if let pov = view.pointOfView {
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
    
    //changing scenes
    private func presentWelcomeScreen() {
        guard let view = gameView else { return }
        view.isUserInteractionEnabled = false
        gameplayScene.isPaused = true
        let transition = SKTransition.fade(withDuration: 1.8)
        currentView = .tapToPlay
        gameMusic.playTheme(scene: newGameScene, directory: "art.scnassets/Audio/Magic.wav")
        
        view.present(newGameScene, with: transition, incomingPointOfView: nil, completionHandler: {
            DispatchQueue.main.async {
                self.gameState = .newGame
                self.newGameScene.isPaused = false
                view.removeCurrentView()
                view.setupWelcomeScreen()
                self.resetGame()
                self.view.isUserInteractionEnabled = true
            }
        })
    }
    
    private func presentGame() {
        guard let view = gameView else { return }
        NotificationCenter.default.post(name: NSNotification.Name("stopVideo"), object: nil)
        view.isUserInteractionEnabled = false
        newGameScene.isPaused = true
        let transition = SKTransition.fade(withDuration: 1.8)
        currentView = .playing
        gameMusic.playTheme(scene: gameplayScene, directory: "art.scnassets/Audio/Music.mp3")
        
        view.present(gameplayScene, with: transition, incomingPointOfView: nil, completionHandler: {
            DispatchQueue.main.async {
                self.gameState = .playing
                self.gameplayScene.isPaused = false
                view.removeCurrentView()
                view.setupHUD()
                self.view.isUserInteractionEnabled = true
            }
        })
    }
    
    private func resetGame() {
        player.playerGameOver()
        
        gameplayScene.rootNode.enumerateChildNodes { (node, _) in
            if let name = node.name {
                switch name {
                case "Enemy":
                    (node as? Enemy)?.enemyGameOver()
                case "Npc":
                    (node as? Npc)?.npcGameOver()
                case "Magic":
                    (node as? MagicElements)?.magicGameOver()
                default:
                    break
                }
            }
        }
    }
    
    @objc func gameOver() {
        guard let view = gameView else { return }
        currentView = .gameOver
        gameState = .paused
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            view.removeCurrentView()
            view.setupGameOver()
            view.isUserInteractionEnabled = true
        }
    }
    
    private func statisticManager() {
        guard let view = gameView else { return }
        if showStatistic { showStatistic = false }
        else { showStatistic = true }
        
        view.showsStatistics = showStatistic
    }
}

// MARK: delegates
extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        if gameState != .playing { return }
        
        for (node, position) in replacementPosition {
            node.position = position
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gameState != .playing || gameplayScene == nil { return }
        
        //reset
        replacementPosition.removeAll()
        maxPenetrationDistance = 0.0
        
        guard
            let view = gameView,
            let scene = view.scene
        else {
            return
        }
        
        let direction = playerDirection()
        guard let somePlayer = player else { return }
        somePlayer.walkInDirection(direction, time: time, scene: scene)
        
        updateFollowersPosition()
        
        //enemy & npc
        gameplayScene.rootNode.enumerateChildNodes { (node, _) in
            if let name = node.name {
                switch name {
                case "Enemy":
                    (node as? Enemy)?.update(with: time, and: scene)
                case "Npc":
                    (node as? Npc)?.update(with: time, and: scene)
                case "Magic":
                    (node as? MagicElements)?.update(with: time, and: scene)
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
        guard let somePlayer = player else { return }
        
        //if player collide with wall
        contact.match(Bitmask().wall) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
        
        // if player collides with enemy
        contact.match(Bitmask().enemy) { (matching, other) in
            let enemy = matching.parent as! Enemy
            if other.name == "collider" { enemy.isCollidingWithPlayer = true }
            if other.name == "weaponCollider" { somePlayer.weaponCollide(with: enemy) }
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
        guard let somePlayer = player else { return }
        
        //if player collide with wall
        contact.match(Bitmask().wall) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
        
        // if player collides with enemy
        contact.match(Bitmask().enemy) { (matching, other) in
            let enemy = matching.parent as! Enemy
            if other.name == "collider" { enemy.isCollidingWithPlayer = true }
            if other.name == "weaponCollider" { somePlayer.weaponCollide(with: enemy) }
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
        guard let somePlayer = player else { return }
        
        // if player collides with enemy
        contact.match(Bitmask().enemy) { (matching, other) in
            let enemy = matching.parent as! Enemy
            if other.name == "collider" { enemy.isCollidingWithPlayer = false }
            if other.name == "weaponCollider" { somePlayer.weaponUnCollide(with: enemy) }
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
