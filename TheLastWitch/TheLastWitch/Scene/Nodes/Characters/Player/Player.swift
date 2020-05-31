//
//  Player.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class Player: SCNNode {
    //nodes
    private var daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var collider: SCNNode!
    private var weaponCollider: SCNNode!
    var npc: Npc? = nil
    var magic: MagicElements? = nil

    //animation
    private var animation: AnimationInterface!

    //movement
    private var previousUdateTime = TimeInterval(0.0)
    private var isWalking: Bool = false {
        didSet {
            if oldValue != isWalking {
                if isWalking {
                    characterNode.removeAnimation(forKey: "idle", blendOutDuration: 0.2)
                } else {
                    characterNode.addAnimation(animation.walkAnimation, forKey: "idle")
                }
            }
        }
    }

    private var directionAngle: Float = 0.0 {
        didSet {
            if directionAngle != oldValue {
                //ustaw akcje rotującą węzeł do konta podanego w radianach
                runAction(SCNAction.rotateTo(
                    x: 0.0,
                    y: CGFloat(directionAngle),
                    z: 0.0, duration: 0.1,
                    usesShortestUnitArc: true)
                )
            }
        }
    }
    
    var touchLocation: CGPoint? = nil
    var dPadOrigin: CGPoint? = nil
    var cameraRotation: Float? = 0

    //collisions
    var replacementPosition: SCNVector3 = SCNVector3Zero
    private var activeWeaponCollideNodes = Set<SCNNode>()
    private var activePlayerCollideNodes = Set<SCNNode>()

    
    //model
    var playerModel: PlayerModel
    let mapper: PlayerCharacterMapping
    private let positionCached: SCNVector3
    
    private var attackTimer: Timer?
    private var attackFrameCounter = 0

    //MARK: initialization
    init(
        playerModel: PlayerModel,
        mapper: PlayerCharacterMapping,
        position: SCNVector3
    ) {
        self.playerModel = playerModel
        self.mapper = mapper
        self.positionCached = position
        super.init()
        
        setupModel()
        animation = PlayerAnimation()
        animation.loadAnimations()
        animation.object.delegate = self
        characterNode.addAnimation(animation.walkAnimation, forKey: "idle")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playerGameOver() {
        playerModel.resetModel()
        self.position = positionCached
        self.isHidden = false
        self.removeAnimation(forKey: "dead")
        self.opacity = 1.0
        isWalking = false
    }

    //MARK:- scene
    private func setupModel() {
        //load dae children
        let playerURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Characters/Hero/walk", withExtension: "dae")
        guard let url = playerURL else { return }
        let playerScene = try! SCNScene(url: url, options: nil)

        for child in playerScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)

        //set mesh name
        guard let node = daeHolderNode.childNode(withName: "Armature", recursively: true) else { return }
        characterNode = node
    }

    //MARK:- movement
    func walkInDirection(_ direction: float3, time: TimeInterval, scene: SCNScene) {
        //jeśli player żyje i nie jest w trakcje akcji ataku
        if playerModel.isDead || playerModel.isAttacking { return }
        if previousUdateTime == 0.0 {
            previousUdateTime = time
        }
        let deltaTime = Float(min (time - previousUdateTime, 1.0 / 60.0))
        let characterSpeed = deltaTime * playerModel.maxSpeed
        previousUdateTime = time

        //ustaw pozycję początkową
        let initialPosition = position

        //porusz się
        if direction.x != 0.0 && direction.z != 0.0 {
//            TODO camera!!!!
            if let dPad = dPadOrigin, let touch = touchLocation, let camera = cameraRotation {
                //zapisuje położenie centrum dPada
                let middleOfCircleX = dPad.x + 75
                let middleOfCircleY = dPad.y + 75
                 //na podstawie położenia dPada i dotyku usera obliczam długości wektorów dla nowego położenia gracza
                let lengthOfX = Float(touch.x - middleOfCircleX)
                let lengthOfY = Float(touch.y - middleOfCircleY)
                var newDirection = float3(x: lengthOfX, y: 0, z: lengthOfY)
                newDirection = normalize(newDirection)

                //zmieniam pozycję postaci
                let pos = float3(position)
                position = SCNVector3(pos + newDirection * characterSpeed)

                //aktualizuję kąt
                let degree = atan2(newDirection.x, newDirection.z)
                directionAngle = degree
                //postać rozpoczęła ruch -> aktualizuje parametr isWalking
                isWalking = true
            }
            //move character
//            let pos = float3(position)
//            position = SCNVector3(pos + direction * characterSpeed)
//
//            //update angle
//            directionAngle = SCNFloat(atan2f(direction.x, direction.z))
//
//            isWalking = true
        } else {
            //postać zakończyła ruch -> aktualizuje parametr isWalking
            isWalking = false
        }

        //aktualizuje wysokość postaci
        var pos = position
        var endpoint0 = pos
        var endpoint1 = pos

        //endpointami staje się position +/- podane wartości
        endpoint0.y -= 0.1
        endpoint1.y += 0.08

        //szukam obiektów o bitmapie równej Bitmask().wall
        let results = scene.physicsWorld.rayTestWithSegment(from: endpoint1, to: endpoint0, options: [.collisionBitMask: Bitmask().wall, .searchMode: SCNPhysicsWorld.TestSearchMode.closest])

        //jeśli znalazło obiekt w result
        if let result = results.first {
            //sprawdzam koordynaty tego obiektu
            let groundAltitude = result.worldCoordinates.y
            pos.y = groundAltitude

            position = pos
        } else {
            //jeśli result nie został znaleziony przywracamy Playerowi jego początkową pozycję
            position = initialPosition
        }
    }

    //MARK:- collisions
    func setupCollider(with scale:CGFloat) {
        //player
        collider = PlayerCollider().setupCollider(with: scale)
        addChildNode(collider)

        //weapon
        weaponCollider = WeaponCollider().setupCollider(with: scale)
        addChildNode(weaponCollider)
    }

    func weaponCollide(with node:SCNNode) {
        activeWeaponCollideNodes.insert(node)
    }

    func weaponUnCollide(with node:SCNNode) {
        activeWeaponCollideNodes.remove(node)
    }
    
    func playerCollide(with node:SCNNode) {
        print("collides: ")
        print(node)
        activePlayerCollideNodes.insert(node)
    }

    func playerUnCollide(with node: SCNNode) {
        activePlayerCollideNodes.remove(node)
    }
    
    //po wykonaniu zadania lub pokonaniu przeciwnika wywoływana jest aktualizacja punktów exp gracza
    func update(with exp: Int) {
        var currentExp = playerModel.expPoints
        var currentLvl = playerModel.level
        var levelUp: Bool = false
        
        //jeśli exp jest więcej niż maxExp, oznacza to że gracz zdobył nowy poziom
        if currentExp + exp >= playerModel.maxExpPoints {
            //obliczam o ile poziomów i exp zmienić aktualne dane
            currentExp = currentExp + exp
            let ileLeveli = Int(floor(Double(currentExp / playerModel.maxExpPoints)))
            currentLvl += ileLeveli
            currentExp -= (ileLeveli * playerModel.maxExpPoints)
            levelUp = true
            playerModel.levelPoints += 1
        } else {
            currentExp += exp
        }
        
        playerModel.level = currentLvl
        playerModel.expPoints = currentExp
   
        //wywołanie dla metody zmieniającej widok paska doświadczenia
        NotificationCenter.default.post(name: NSNotification.Name("expChanged"), object: nil, userInfo: ["playerMaxExp": playerModel.maxExpPoints, "currentExp": playerModel.expPoints, "levelUp": levelUp])
    }
    
    func updateQuest(with type: TargetType) {
        for quest in playerModel.quests {
            if let index = quest.targets.firstIndex(of: type) {
                //z listy aktywnych celi usuwany jest cel z pasującym identyfikatorem
                quest.targets.remove(at: index)
            }
            if quest.targets == [] {
                //no more targets in quest == quest completed
                //jeśli w danym zadaniu lista celi jest pusta, oznacza to ze zostało ono zakończone i zmieniony zostaje jego status
                quest.isActive = false
                
                NotificationCenter.default.post(name: NSNotification.Name("questStatusChanged"), object: nil, userInfo: ["questId": quest.id, "activeStatus": quest.isActive, "finishedStatus": quest.isFinished])
                
                //SHOW INFO ! ! ! ! !
                print("COMPLETED")
            }
        }
    }
    
    func questManager() {
        if
            playerModel.quests.count <= 5,
            let quest = npc?.npcModel.quest
        {
            var canAddQuest: Bool = true
            for playerQuest in playerModel.quests {
                if playerQuest.id == quest.id {
                    canAddQuest = false
                }
            }
            if canAddQuest {
                //npc może przedstawić graczowi zadanie
                npc?.npcModel.updateDialogWithQuest()
                playerModel.quests.append(quest)
            }
        }
        if let quest = npc?.npcModel.quest, !quest.isActive, !quest.isFinished {
            npc?.npcModel.finishQuestDialogUpdate(quest: quest.desc)
            //zadanie jest zakończone, zmieniany jest status zadania w modelu npc
            quest.isFinished = true
            //gracz dostaje wynagrodzenie za wykonanie zadania
            update(with: quest.exp)
            
            for playerQuest in playerModel.quests {
                if playerQuest.id == quest.id {
                    //zmieniany jest status zadania w modelu gracza
                    playerQuest.isFinished = true
                }
            }
        }
        if let target = magic?.magicElementModel.type,
            target == .bluePortal {
            //wygrana, cel gry został osiągnięty
            playerModel.gameOver = true
        }
    }

    //graczowi zostały zadane obrażenia
    func gotHit(with hpPoints: Int) {
        //zmniejszam aktualny poziom życia
        playerModel.hpPoints -= hpPoints
        //aktualizuje widok paska życia nowymi danymi
        NotificationCenter.default.post(name: NSNotification.Name("hpChanged"), object: nil, userInfo: ["playerMaxHp": playerModel.maxHpPoints, "currentHp": playerModel.hpPoints])
        //jeśli życie jest <= 0 gracz ginie
        if playerModel.hpPoints <= 0 {
            die()
        }
    }
    
    @objc func attackTimerTicked(timer: Timer) {
        attackFrameCounter += 1
        if attackFrameCounter == 12 {
            for node in activeWeaponCollideNodes {
                if let enemy = node as? Enemy {
                    enemy.gotHit(by: node, with: Int(playerModel.maxMagic * 100))
                }
            }
        }
    }
    
    func walks(walks: Bool) {
        isWalking = walks
    }
    
    func updateHealth() {
        playerModel.maxHpPoints += 10
        playerModel.hpPoints += 10
        playerModel.levelPoints -= 1
        updateCharacterModelData()
    }
    
    func updateSpeed() {
        playerModel.maxSpeed += 0.2
        playerModel.levelPoints -= 1
        updateCharacterModelData()
    }
    
    func updateMagic() {
        playerModel.maxMagic += 0.5
        playerModel.levelPoints -= 1
        updateCharacterModelData()
    }
    
    func updateModelData() {
        let levelUp = playerModel.expPoints >= playerModel.maxExpPoints ? true : false
        NotificationCenter.default.post(name: NSNotification.Name("hpChanged"), object: nil, userInfo: ["playerMaxHp": playerModel.maxHpPoints, "currentHp": playerModel.hpPoints])
        NotificationCenter.default.post(name: NSNotification.Name("expChanged"), object: nil, userInfo: ["playerMaxExp": playerModel.maxExpPoints, "currentExp": playerModel.expPoints, "levelUp": levelUp])
    }
    
    func updateCharacterModelData() {
       //zmapuj player model na PlayerCharacterStatsModel
        let model = mapper.map(entity: playerModel)
       //wyświetlaj przycisk do ulepszenia prędkości tylko jeśli aktualna prędkość postaci jest mniejsza niż 3
        let speedButton = playerModel.maxSpeed <= 6
        
        //update level
        NotificationCenter.default.post(name: NSNotification.Name("levelUpdate"), object: nil, userInfo: ["level": model.level, "levelPoints": model.levelPoints])
        
        //update stats
        NotificationCenter.default.post(name: NSNotification.Name("expUpdate"), object: nil, userInfo: ["expPoints": model.maxExp, "currentPoints": model.currentExp])
        
        NotificationCenter.default.post(name: NSNotification.Name("healthUpdate"), object: nil, userInfo: ["healthPoints": model.health, "button": model.isAddButtonActive])
        NotificationCenter.default.post(name: NSNotification.Name("speedUpdate"), object: nil, userInfo: ["speedPoints": model.speed, "button": (model.isAddButtonActive && speedButton)])
        NotificationCenter.default.post(name: NSNotification.Name("magicUpdate"), object: nil, userInfo: ["magicPoints": model.magic, "button": model.isAddButtonActive])
        
        //update quests
        NotificationCenter.default.post(name: NSNotification.Name("questsUpdate"), object: nil, userInfo: ["questList": model.questList])
    }
}

//MARK:- extensions
extension Player: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard
            let id = anim.value(forKey: "attackKey") as? String
        else {
            return
        }
        if id == "attack" {
            attackTimer?.invalidate()
            attackFrameCounter = 0
            playerModel.isAttacking = false
        }
    }
}

extension Player: BattleAction {
    func attack() {
       //jeśli player nie jest już w trakcie ataku lub interakcji
        if playerModel.isAttacking || playerModel.isDead || playerModel.isInteracting { return }
        playerModel.isAttacking = true
        isWalking = false

        DispatchQueue.main.async {
            //dodaje animację ataku i w attackTimerTicked po sprawdzeniu węzłów kolidujących z bronią postaci wywołujemy akcję gotHit na walczących przeciwnikach
            self.attackTimer?.invalidate()
            self.attackTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.attackTimerTicked), userInfo: nil, repeats: true)
            self.characterNode.addAnimation(self.animation.attackAnimation, forKey: "attack")
        }
    }
    
    func die() {
       //aktualizuje dane gracza i dodaje do jego węzła animację śmierci
        playerModel.isDead = true
        guard let node = characterNode else { return }
        node.addAnimation(animation.deadAnimation, forKey: "deadKey")
        
        //po zagraniu animacji wywołuję akcję czekania 2
        let wait = SCNAction.wait(duration: 2.0)
        //ustawiam akcję zmiany widoczności na 0
        let fadeOut = SCNAction.fadeOpacity(to: 0, duration: 1.0)
        //zmieniam parametr isHidden dla węzła i umieszczam tą zmianę w akcji hide
        let hide = SCNAction.run { (node) in
            node.isHidden = true
            //add effect
        }
        //wywołuje akcje w sekwencji
        let seq = SCNAction.sequence([wait, fadeOut, hide])
        runAction(seq)
        //prezentuję ekran porażki
        NotificationCenter.default.post(name: NSNotification.Name("resetGame"), object: nil, userInfo:[:])
    }
}
