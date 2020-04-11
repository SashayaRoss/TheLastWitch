//
//  Player.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

final class Player: SCNNode {
    //nodes
    private var daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var collider: SCNNode!
    private var weaponCollider: SCNNode!
    var npc: Npc!

    //animation
    private var animation: AnimationInterface!

    //movement
    private var previousUdateTime = TimeInterval(0.0)
    private var isWalking: Bool = false {
        didSet {
            if oldValue != isWalking {
                if isWalking {
                    characterNode.addAnimation(animation.walkAnimation, forKey: "walk")
                } else {
                    characterNode.removeAnimation(forKey: "walk", blendOutDuration: 0.2)
                }
            }
        }
    }

    private var directionAngle:Float = 0.0 {
        didSet {
            if directionAngle != oldValue {
                // action that rotates the node to an angle in radian.
                runAction(SCNAction.rotateTo(x: 0.0, y: CGFloat(directionAngle), z: 0.0, duration: 0.1, usesShortestUnitArc: true))
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
    let playerModel: PlayerModel
    let mapper: PlayerCharacterMapping
    
    private var attackTimer: Timer?
    private var attackFrameCounter = 0

    //MARK: initialization
    init(playerModel: PlayerModel, mapper: PlayerCharacterMapping) {
        self.playerModel = playerModel
        self.mapper = mapper
        super.init()
        
        setupModel()
        animation = PlayerAnimation()
        animation.loadAnimations()
        animation.object.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- scene
    private func setupModel() {
        //load dae childs
        let playerURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Characters/Hero/idle", withExtension: "dae")
        let playerScene = try! SCNScene(url: playerURL!, options: nil)

        for child in playerScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)

        //set mesh name
        characterNode = daeHolderNode.childNode(withName: "Bip01", recursively: true)!
    }

    //MARK:- movement
    func walkInDirection(_ direction: float3, time: TimeInterval, scene: SCNScene) {
        if playerModel.isDead || playerModel.isAttacking { return }
        if previousUdateTime == 0.0 {
            previousUdateTime = time
        }
        let deltaTime = Float(min (time - previousUdateTime, 1.0 / 60.0))
        let characterSpeed = deltaTime * playerModel.maxSpeed
        previousUdateTime = time

        let initialPosition = position

        //move
        if direction.x != 0.0 && direction.z != 0.0 {
            //camera!!!!
            if let dPad = dPadOrigin, let touch = touchLocation, let camera = cameraRotation {
                let middleOfCircleX = dPad.x + 75
                let middleOfCircleY = dPad.y + 75
                let lengthOfX = Float(touch.x - middleOfCircleX)
                let lengthOfY = Float(touch.y - middleOfCircleY)
                var newDirection = float3(x: lengthOfX, y: 0, z: lengthOfY)
                newDirection = normalize(newDirection)
                print("x: \(touch.x), y: \(touch.y)")
                
                //move character
                let pos = float3(position)
                position = SCNVector3(pos + newDirection * characterSpeed)

                //update angle
                let degree = atan2(newDirection.x, newDirection.z)
                directionAngle = degree

                isWalking = true
            }
        } else {
            isWalking = false
        }

        //update altitude
        var pos = position
        var endpoint0 = pos
        var endpoint1 = pos

        endpoint0.y -= 0.1
        endpoint1.y += 0.08

        let results = scene.physicsWorld.rayTestWithSegment(from: endpoint1, to: endpoint0, options: [.collisionBitMask: Bitmask().wall, .searchMode: SCNPhysicsWorld.TestSearchMode.closest])

        if let result = results.first {
            let groundAltitude = result.worldCoordinates.y
            pos.y = groundAltitude

            position = pos
        } else {
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
        activePlayerCollideNodes.insert(node)
    }

    func playerUnCollide(with node: SCNNode) {
        activePlayerCollideNodes.remove(node)
    }
    
    func update(with exp: Int) {
        var currentExp = playerModel.expPoints
        var currentLvl = playerModel.level
        var levelUp: Bool = false
        
        if currentExp + exp >= playerModel.maxExpPoints {
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
   
        NotificationCenter.default.post(name: NSNotification.Name("expChanged"), object: nil, userInfo: ["playerMaxExp": playerModel.maxExpPoints, "currentExp": playerModel.expPoints, "levelUp": levelUp])
    }
    
    func updateQuest(with name: String) {
        for quest in playerModel.quests {
            if let index = quest.targets.index(of: name) {
                quest.targets.remove(at: index)
            }
            if quest.targets == [] {
                //no more targets in quest == quest completed
                quest.isActive = false
                
                NotificationCenter.default.post(name: NSNotification.Name("questStatusChanged"), object: nil, userInfo: ["questId": quest.id, "activeStatus": quest.isActive, "finishedStatus": quest.isFinished])
                
                //SHOW INFO ! ! ! ! !
                print("COMPLETED")
            }
        }
    }
    
    func questManager() {
        //player can accept more quests and npc has quests to give
        if
            playerModel.quests.count <= 8,
            let quest = npc.npcModel.quest
        {
            var canAddQuest: Bool = true
            for playerQuest in playerModel.quests {
                if playerQuest.id == quest.id {
                    canAddQuest = false
                }
            }
            if canAddQuest {
                //add quest desc to npc dialog
                npc.npcModel.updateDialogWithQuest()
                playerModel.quests.append(quest)
            }
        }
        if let quest = npc.npcModel.quest, !quest.isActive, !quest.isFinished {
            npc.npcModel.finishQuestDialogUpdate(quest: quest.desc)
            //Finish quest
            quest.isFinished = true
            update(with: quest.exp)
            
            for playerQuest in playerModel.quests {
                if playerQuest.id == quest.id {
                    playerQuest.isFinished = true
                }
            }
        }
    }

    
    func gotHit(with hpPoints: Int) {
        playerModel.hpPoints -= hpPoints
        NotificationCenter.default.post(name: NSNotification.Name("hpChanged"), object: nil, userInfo: ["playerMaxHp": playerModel.maxHpPoints, "currentHp": playerModel.hpPoints])

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
        NotificationCenter.default.post(name: NSNotification.Name("hpChanged"), object: nil, userInfo: ["playerMaxHp": playerModel.maxHpPoints, "currentHp": playerModel.hpPoints])
        NotificationCenter.default.post(name: NSNotification.Name("expChanged"), object: nil, userInfo: ["playerMaxExp": playerModel.maxExpPoints, "currentExp": playerModel.expPoints])
    }
    
    func updateCharacterModelData() {
        let model = mapper.map(entity: playerModel)
        let speedButton = playerModel.maxSpeed <= 3
        
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
            let id = anim.value(forKey: "animationId") as? String
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
        if playerModel.isAttacking || playerModel.isDead || playerModel.isInteracting { return }
        playerModel.isAttacking = true
        isWalking = false

        DispatchQueue.main.async {
            self.attackTimer?.invalidate()
            self.attackTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.attackTimerTicked), userInfo: nil, repeats: true)
            self.characterNode.addAnimation(self.animation.attackAnimation, forKey: "attack")
        }
    }
    
    func die() {
        playerModel.isDead = true
        characterNode.removeAllActions()
        characterNode.removeAllAnimations()
        characterNode.addAnimation(animation.deadAnimation, forKey: "dead")
        print("GAME OVER")
    }
}
