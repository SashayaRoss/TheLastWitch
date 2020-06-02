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
    var newGameScene: SCNScene!
    var gameplayScene: SCNScene!
    var transitionScene: SCNScene!
    
    //general
    var gameState: GameState = .newGame
    var currentView: CurrentView = .playing
    private var showStatistic: Bool = false
    
    //nodes
    private var player: Player!
    private var light: SCNNode!
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
    var mainLight: MainLight!
    var collision: Collision!
    var playerFactory: PlayerFactory!
    var enemyFactory: EnemyFactory!
    var npcFactory: NPCFactory!
    var magicFactory: InteractiveObjectsFactory!

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
        
        //setup node'ów i ich inicjalizacja
        playerFactory = PlayerFactory(scene: scene, model: model, mapper: mapper)
        player = playerFactory.getPlayer()
        mainCamera = MainCamera(scene: scene)
        mainLight = MainLight(scene: scene)
        collision = Collision(scene: scene)
        enemyFactory = EnemyFactory(scene: scene, gameView: view, player: player)
        npcFactory = NPCFactory(scene: scene, gameView: view, player: player)
        magicFactory = InteractiveObjectsFactory(scene: scene, gameView: view, player: player)
        
        light = mainLight.setup()
        cameraStick = mainCamera.setup()
        
        //ładowanie dźwięku
        gameMusic.loadSounds()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(gameOver), name: NSNotification.Name("resetGame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(victory), name: NSNotification.Name("victory"), object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
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
            // jeśli obszar kontaktu usera z ekranem przypada na pole określane przez virtualNodeBounds d-pada
            if view.hudView.dpadNode.virtualNodeBounds().contains(touch.location(in: view)) {
                //zapisuje punkt zetknięcia z padem
                if padTouch == nil {
                    padTouch = touch
                    controllerStoredDirection = float2(0.0)
                }
            //jeśli dotknięto przycisku ataku
            } else if view.hudView.attackButtonNode.virtualNodeBounds().contains(touch.location(in: view)) {
                if let activePlayer = player {
                    //jeśli player prowadzi interakcje z npc
                    if let npc = activePlayer.npc, npc.isInteracting {
                        player.playerModel.isInteracting = true
                        player.playerModel.currentInteraction = .npc
                    }
                    //jeśli player prowadzi interakcje z przedmiotem
                    if let magic = activePlayer.magic, magic.isInteracting {
                        player.playerModel.isInteracting = true
                        player.playerModel.currentInteraction = .magic
                    }
                    
                    if player.playerModel.isInteracting {
                        //player jest w trakcie interakcji
                        //gra zostaje zatrzymana i rozpoczyna się dialog
                        activePlayer.walks(walks: false)
                        gameState = .paused
                        currentView = .dialog
                        player.questManager()
                        view.removeCurrentView()
                        view.setupDialog()
                        dialogAction(touches: touches)
                    } else {
                        //player jest w trakcie walki: wykonuje akcję ataku i odtwarzany jest dźwięk „Magic”
                        activePlayer.attack()
                        gameMusic.playSound(node: activePlayer, name: "Magic")
                    }
                }
            //jeśli dotknięto przycisku opcji
            } else if view.hudView.optionsButtonNode.virtualNodeBounds().contains(touch.location(in: view)) {
                //zatrzymuję grę, zmieniam aktualny widok i usuwam obecny widok
                gameState = .paused
                currentView = .options
                view.removeCurrentView()
                view.setupOptions()
                
            //jeśli dotknięto przycisku menu postaci
            } else if view.hudView.characterButtonNode.virtualNodeBounds().contains(touch.location(in: view)) {
                //zatrzymuję grę, zmieniam aktualny widok, usuwam obecny widok i uaktualniam dane o graczu
                gameState = .paused
                currentView = .character
                view.removeCurrentView()
                view.setupCharacter()
                player.updateCharacterModelData()
                
            } else if cameraTouch == nil {
                cameraTouch = touches.first
            }
            //kontakt z d-pad'em zakończył się, przerywam funkcje
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
                    //rozmawia z npc
                    case .npc:
                       //jeśli rozmowa może być nadal prowadzona (obiekt npc istnieje, a przedstawiany przez niego tekst nie skończył się)
                        if
                            let npc = activePlayer.npc,
                            (npc.currentDialog < npc.npcModel.dialog.count)
                        {
                            npc.dialog()
                        } else {
                            if let npc = activePlayer.npc {
                                npc.currentDialog = 0
                            }
                            //dialog zakończył się, usuwam obecny widok i prezentuje nowy
                            view.removeCurrentView()
                            currentView = .playing
                            gameState = .playing
                            view.setupHUD()
                            activePlayer.updateModelData()
                            activePlayer.playerModel.currentInteraction = .none
                        }
                    //logika rozmowy z przedmiotem przebiega analogicznie
                    case .magic:
                        if
                            let magic = activePlayer.magic,
                            (magic.currentDialog < magic.interactiveObjectModel.dialog.count)
                        {
                            magic.dialog()
                        } else {
                            if let magic = activePlayer.magic {
                               magic.currentDialog = 0
                                if player.playerModel.gameOver == true {
                                    NotificationCenter.default.post(name: NSNotification.Name("victory"), object: nil, userInfo:[:])
                                }
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
            //gracz wybrał przycisk powrotu do gry
            if view.characterView.goBack.virtualNodeBounds().contains(touch.location(in: view)) {
                view.removeCurrentView()
                currentView = .playing
                view.setupHUD()
                if let activePlayer = player {
                    activePlayer.updateModelData()
                }
            } else if
                //gracz wybrał przycisk dodania punktów życia i ma nierozdysponowane punkty
                view.characterView.health.virtualNodeBounds().contains(touch.location(in: view)),
                player.playerModel.levelPoints >= 1
            {
                if let activePlayer = player {
                    activePlayer.updateHealth()
                }
            } else if
                 //dodanie punktów do szybkości i magii odbywa się w sposób analogiczny
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
                //gracz wybrał przycisk powrotu do gry
                view.removeCurrentView()
                currentView = .playing
                view.setupHUD()
                if let activePlayer = player {
                    activePlayer.updateModelData()
                }
            } else if
                view.optionsView.newGame.virtualNodeBounds().contains(touch.location(in: view))
            {
                //gracz wybrał nową grę 
                presentWelcomeScreen()
            } else if
                view.optionsView.devMode.virtualNodeBounds().contains(touch.location(in: view))
            {
                //włącza tryb developerski
                statisticManager()
            }
            else if
                view.optionsView.music.virtualNodeBounds().contains(touch.location(in: view))
            {
                //jeśli nie jest odtwarzana muzyka, dodaj do węzła nowy audioPlayer
                if gameplayScene.rootNode.audioPlayers == [] {
                    gameMusic.playTheme(scene: gameplayScene, directory: "art.scnassets/Audio/Music.mp3")
                } else {
                    //jeśli muzyka jest odtwarzana, wyłącz ją, usuwając ją z węzła
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
        light.position = SCNVector3Make(character.position.x, 0.0, character.position.z)
    }
    
    //changing scenes
    private func presentWelcomeScreen() {
        guard let view = gameView else { return }
        //wyłączam możliwość interakcji z ekranem dla usera i zmieniam statusy gry
        view.isUserInteractionEnabled = false
        gameplayScene.isPaused = true
       //ustawiam przejście do nowej sceny i zamieniam muzykę
        let transition = SKTransition.fade(withDuration: 1.8)
        gameMusic.playTheme(scene: newGameScene, directory: "art.scnassets/Audio/Magic.wav")
        
        view.present(newGameScene, with: transition, incomingPointOfView: nil, completionHandler: {
            //wywołuje akcję na głównym wątku
            DispatchQueue.main.async {
                //zmieniam statusy gry i prezentuje nowy widok
                self.gameState = .newGame
                self.newGameScene.isPaused = false
                view.removeCurrentView()
                view.setupWelcomeScreen()
                self.resetGame()
                self.currentView = .tapToPlay 
                //włączam możliwość interakcji z ekranem dla usera
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
       //wywołuje metody gameOver na węzłach
        player.playerGameOver()
        
        gameplayScene.rootNode.enumerateChildNodes { (node, _) in
            if let name = node.name {
                switch name {
                case "Enemy":
                    (node as? Enemy)?.enemyGameOver()
                case "Npc":
                    (node as? Npc)?.npcGameOver()
                case "Interactive":
                    (node as? InteractiveObject)?.magicGameOver()
                default:
                    break
                }
            }
        }
    }
    
    @objc func victory() {
        presentWelcomeScreen()
    }
    
    @objc func gameOver() {
        guard let view = gameView else { return }
        currentView = .gameOver
        gameState = .paused
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            view.removeCurrentView()
            view.setupGameOver()
            view.isUserInteractionEnabled = true
        }
    }
    
    //pokazywanie i chowanie menu statystyk
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
        //jeśli gra jest w stanie zakończenia lub nowej gry, wychodzę z metody
        if gameState != .playing { return }
        
        //ustawiam nowe pozycje dla węzłów w replacementPosition
        for (node, position) in replacementPosition {
            node.position = position
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gameState != .playing || gameplayScene == nil { return }
        
        //resetuje stare parametry
        replacementPosition.removeAll()
        maxPenetrationDistance = 0.0
        
        guard
            let view = gameView,
            let scene = view.scene
        else {
            return
        }
        //aktualizuje położenie gracza
        let direction = playerDirection()
        guard let somePlayer = player else { return }
        somePlayer.walkInDirection(direction, time: time, scene: scene)
        //aktualizuje położenie kamery i oświetlenia
        updateFollowersPosition()
        
        //dla każdego węzła znajdującego się w grafie wywołuje odpowiednie dla nich medoty aktualizacji
        gameplayScene.rootNode.enumerateChildNodes { (node, _) in
            if let name = node.name {
                switch name {
                //jeśli node znajduje się w grupie „Enemy” do odpowiada mu wywołanie update z klasy enemy, analogicznie dla pozostałych węzłów
                case "Enemy":
                    (node as? Enemy)?.update(with: time, and: scene)
                case "Npc":
                    (node as? Npc)?.update(with: time, and: scene)
                case "Interactive":
                    (node as? InteractiveObject)?.update(with: time, and: scene)
                default:
                    break
                }
            }
        }
    }
}

extension GameViewController: SCNPhysicsContactDelegate {
    //wykryte zostało rozpoczęcie kontaktu między dwoma elementami
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
        contact.match(Bitmask().interactiveObject) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }

    //dostępne są nowe informacje o trwającym kontakcie
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
        contact.match(Bitmask().interactiveObject) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }
    
    //kontakt zakończył się
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
        contact.match(Bitmask().interactiveObject) { (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }
}
