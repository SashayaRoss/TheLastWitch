//
//  GameViewController.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 26/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import UIKit
import SceneKit

let BitmaskPlayer = 1
let BitmaskPlayerWeapon = 2
let BitmaskWall = 64
let BitMaskEnemy = 3

class GameViewController: UIViewController {

    var gameView: GameView {
        return view as! GameView
    }
    
    //scene
    var sceneView: SCNView!
    var mainScene: SCNScene!
    
    //general
    var gameState: GameState = .loading
    
    //nodes
    private var player: Player?
    private var cameraStick: SCNNode!
    private var cameraXHolder: SCNNode!
    private var cameraYHolder: SCNNode!
    private var lightStick: SCNNode!
    
    //movement
    private var controllerStoredDirection = float2(0.0)
    private var padTouch: UITouch?
    private var cameraTouch: UITouch?
    
    //collisions
    private var maxPenetrationDistance = CGFloat(0.0)
    private var replacementPosition = [SCNNode: SCNVector3]()
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupPlayer()
        setupCamera()
        setupLight()
        setupWallBitmasks()
        
        gameState = .playing
    }
    
    //MARK: scene
    private func setupScene() {
        gameView.antialiasingMode = .multisampling4X
        gameView.delegate = self
        gameView.isUserInteractionEnabled = true

        mainScene = SCNScene(named: "art.scnassets/Scenes/Stage1.scn")
        mainScene.physicsWorld.contactDelegate = self
        
        gameView.scene = mainScene
        gameView.isPlaying = true
    }
    
    override var shouldAutorotate: Bool {
        return false
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
    
    //MARK: player
    private func setupPlayer() {
        player = Player(animation: PlayerAnimation())
        let playerScale = Float(0.003)
        
        guard let existingPlayer = player else { return }
        existingPlayer.scale = SCNVector3Make(playerScale, playerScale, playerScale)
        existingPlayer.position = SCNVector3Make(0.0, 0.0, 0.0)
        existingPlayer.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        
        mainScene.rootNode.addChildNode(existingPlayer)
        existingPlayer.setupCollider(with: CGFloat(playerScale))
    }
    
    //MARK: touches + movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if gameView.dpadNode.virtualNodeBounds().contains(touch.location(in: gameView)) {
                if padTouch == nil {
                    padTouch = touch
                    controllerStoredDirection = float2(0.0)
                }
            } else if cameraTouch == nil {
                    cameraTouch = touches.first
            }
            if padTouch != nil {
                break
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = padTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))

            let vMix = mix(controllerStoredDirection, displacement, t: 0.1)
            let vClamp = clamp(vMix, min: -1.0, max: 1.0)

            controllerStoredDirection = vClamp
        } else if let touch = cameraTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))
            panCamera(displacement)
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
    
    //MARK: walls collision
    private func setupWallBitmasks() {
        var collisionNodes = [SCNNode]()
        mainScene.rootNode.enumerateChildNodes { (node, _) in
            switch node.name {
            case let .some(s) where s.range(of: "collision") != nil:
                collisionNodes.append(node)
            default:
                break
            }
        }
        for node in collisionNodes {
            node.physicsBody = SCNPhysicsBody.static()
            node.physicsBody!.categoryBitMask = BitmaskWall
            node.physicsBody!.physicsShape = SCNPhysicsShape(node: node, options: [.type: SCNPhysicsShape.ShapeType.concavePolyhedron as NSString])
        }
    }
    
    private func characterNode(_ characterNode: SCNNode, hitWall wall: SCNNode, withContact contact: SCNPhysicsContact) {
        if characterNode.name != "collider" { return }
        if maxPenetrationDistance > contact.penetrationDistance { return }
        maxPenetrationDistance = contact.penetrationDistance
        
        var characterPosition = float3(characterNode.parent!.position)
        var positionOffset = float3(contact.contactNormal) * Float(contact.penetrationDistance)
        positionOffset.y = 0
        characterPosition += positionOffset
        
        replacementPosition[characterNode.parent!] = SCNVector3(characterPosition)
    }
    
    
    //MARK: camera
    private func setupCamera() {
        cameraStick = mainScene.rootNode.childNode(withName: "CameraStick", recursively: false)!
        cameraYHolder = mainScene.rootNode.childNode(withName: "yHolder", recursively: true)!
        cameraXHolder = mainScene.rootNode.childNode(withName: "xHolder", recursively: true)!
    }
    
    private func panCamera(_ direction: float2) {
        var directionToPan = direction
        directionToPan *= float2(1.0, -1.0)
        
        let panReducer = Float(0.005)
        
        let currX = cameraXHolder.rotation
        var xRotationValue = currX.w - directionToPan.x * panReducer
        cameraXHolder.rotation = SCNVector4Make(0, 1, 0, xRotationValue)
        
        let currY = cameraYHolder.rotation
        var yRotationValue = currY.w + directionToPan.y * panReducer
        
        if yRotationValue < -0.94 {
            yRotationValue = -0.94
        }
        if yRotationValue > 0.66 {
            yRotationValue = 0.66
        }

        cameraYHolder.rotation = SCNVector4Make(1, 0, 0, yRotationValue)
    }
    
    private func setupLight() {
        lightStick = mainScene.rootNode.childNode(withName: "LightStick", recursively: false)!
    }
    
    //MARK: game loop functions
    private func updateFollowersPosition() {
        guard let character = player else { return }
        cameraStick.position = SCNVector3Make(character.position.x, 0.0, character.position.z)
        lightStick.position = SCNVector3Make(character.position.x, 0.0, character.position.z)
    }
    
    //MARK: enemies

}

//MARK: extensions
extension float2 {
    init(_ v: CGPoint) {
        self.init(Float(v.x), Float(v.y))
    }
}

extension SCNPhysicsContact {
    func match(_ cathegory: Int, block: (_ matching: SCNNode, _ other: SCNNode) -> Void) {
        if self.nodeA.physicsBody!.categoryBitMask == cathegory {
            block(self.nodeA, self.nodeB)
        }
        if self.nodeB.physicsBody!.categoryBitMask == cathegory {
            block(self.nodeB, self.nodeA)
        }
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
        if gameState != .playing { return }
        
        //reset
        replacementPosition.removeAll()
        maxPenetrationDistance = 0.0
        
        let scene = gameView.scene!
        let direction = playerDirection()
        player!.walkInDirection(direction, time: time, scene: scene)
        
        updateFollowersPosition()
    }
}

extension GameViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if gameState != .playing { return }
        print(contact.nodeA.name)
        print(contact.nodeB.name)
        
        //if player collide with wall
        contact.match(BitmaskWall) {
            (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        //if player collide with wall
        contact.match(BitmaskWall) {
            (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        //
    }
}
