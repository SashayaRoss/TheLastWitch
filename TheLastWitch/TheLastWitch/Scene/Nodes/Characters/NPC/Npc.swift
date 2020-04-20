//
//  Npc.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import Foundation
import SceneKit

final class Npc: SCNNode {
    //general
    var gameView: GameView!
    
    //nodes
    private let daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var player: Player!
    
    //interaction
    var npcModel: NpcModel!
    var currentDialog: Int = 0
    
    //animation
    private var animation: AnimationInterface!
    
    //movement
    var isInteracting: Bool = false
    
    //collision
    var isCollidingWithPlayer = false {
        didSet {
            if oldValue != isCollidingWithPlayer {
                if isCollidingWithPlayer {
                    isInteracting = true
                }
            }
        }
    }
    
    //MARK: init
    init(player: Player, view: GameView, npcModel: NpcModel) {
        super.init()
        
        self.gameView = view
        self.player = player
        self.npcModel = npcModel
        
        setupModelScene()
        setupObservers()
        animation = NpcAnimation()
        animation.loadAnimations()
        animation.object.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: scene
    private func setupModelScene() {
        name = "Npc"
        let idleURL = Bundle.main.url(forResource: npcModel.model, withExtension: "dae")
        let idleScene = try! SCNScene(url: idleURL!, options: nil)
        
        for child in idleScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        //set mesh name
        characterNode = daeHolderNode.childNode(withName: "Bip01", recursively: true)!
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(questStatusChanged), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func npcGameOver() {
        npcModel.resetModel()
        self.isHidden = false
    }
    
    func update(with time: TimeInterval, and scene: SCNScene) {
        guard
            let player = player
        else {
            return
        }

        //get distance
        let distance = GameUtils.distanceBetweenVectors(vector1: player.position, vector2: position)

        if distance < npcModel.noticeDistance && distance > 0.01 {
            isInteracting = true
            player.npc = self
        } else {
            isInteracting = false
        }
        player.playerModel.isInteracting = isInteracting
    }
    
    //MARK: collision
    func setupCollider(scale: CGFloat) {
        //dodanie collidera do każdego węzła npc
        let collider = NpcCollider().setupCollider(with: scale)
        
        gameView.prepare([collider]) { (finished) in
            self.addChildNode(collider)
        }
    }
    
    func interacts(dialog: String) {
        NotificationCenter.default.post(name: NSNotification.Name("dialogPop"), object: nil, userInfo: ["dialogText": dialog])
    }
    
    func dialog() {
        interacts(dialog: npcModel.dialog[currentDialog])
        currentDialog += 1
    }
    
    @objc func questStatusChanged(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let id = userInfo["questId"] as? Int,
            let isActive = userInfo["activeStatus"] as? Bool,
            let isFinished = userInfo["finishStatus"] as? Bool
        else {
            return
        }
        if npcModel.quest?.id == id {
            npcModel.quest?.isActive = isActive
            npcModel.quest?.isFinished = isFinished
        }
    }
}

extension Npc: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let id = anim.value(forKey: "animationId") as? String else { return }
        if id == "interaction" {
            //interaction animation
        }
    }
}

