//
//  interactiveObject.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class Interactive: SCNNode {
    //general
    var gameView: GameView!
    
    //nodes
    private let daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var player: Player!
    
    //interaction
    var interactiveObjectModel: InteractiveObjectModel!
    var currentDialog: Int = 0
    
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
    init(player: Player, view: GameView, interactiveObjectModel: InteractiveObjectModel) {
        super.init()
        
        self.gameView = view
        self.player = player
        self.interactiveObjectModel = interactiveObjectModel
        
        setupModelScene()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: scene
    private func setupModelScene() {
        name = "InteractiveObject"
        let idleURL = Bundle.main.url(forResource: interactiveObjectModel.model, withExtension: "dae")
        guard let url  = idleURL else {
            return
        }
        let idleScene = try! SCNScene(url: url, options: nil)
        
        for child in idleScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)

        //set mesh name
        guard let node = daeHolderNode.childNode(withName: "Cube", recursively: true) else { return }
        characterNode = node
    }
    
    func magicGameOver() {
        interactiveObjectModel.resetModel()
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

        if distance < interactiveObjectModel.noticeDistance && distance > 0.01 {
            isInteracting = true
            player.magic = self
        } else {
            isInteracting = false
        }
        player.playerModel.isInteracting = isInteracting
    }
    
    //MARK: collision
    func setupCollider(scale: CGFloat) {
        let collider = InteractiveObjectCollider().setupCollider(with: scale)
        
        gameView.prepare([collider]) { (finished) in
            self.addChildNode(collider)
        }
    }
    
    func interacts(dialog: String) {
        NotificationCenter.default.post(name: NSNotification.Name("dialogPop"), object: nil, userInfo: ["dialogText": dialog])
    }
    
    func dialog() {
        interacts(dialog: interactiveObjectModel.dialog[currentDialog])
        currentDialog += 1
    }
    
    private func removePerkFromDialog() {
        guard let givenPerk = interactiveObjectModel.dialog.last else { return }
        interactiveObjectModel.dialog.removeLast()
        interactiveObjectModel.dialog.append("\(givenPerk) [Recived]")
    }
    
    func perkPlayer() {
        let model = player.playerModel
        
        switch interactiveObjectModel.perk {
        case .fullHP:
            model.hpPoints = model.maxHpPoints
            removePerkFromDialog()
        case .exp:
            player.update(with: 50)
            removePerkFromDialog()
        case .points:
            model.levelPoints += 1
            removePerkFromDialog()
        default:
            break
        }
        interactiveObjectModel.perk = .used
    }
}
