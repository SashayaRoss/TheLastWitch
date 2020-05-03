//
//  MainCamera.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class MainCamera {
    let scene: SCNScene
    
    private var cameraStick: SCNNode!
    private var cameraXHolder: SCNNode!
    private var cameraYHolder: SCNNode!
    
    init(scene: SCNScene) {
        self.scene = scene
    }
    
    func panCamera(_ direction: float2) {
        if cameraStick == nil, cameraXHolder == nil, cameraYHolder == nil { return }
        
        var directionToPan = direction
        directionToPan *= float2(1.0, -1.0)
        
        let speedReducer = Float(0.005)
        
        let currX = cameraXHolder.rotation
        let xRotationValue = currX.w - directionToPan.x * speedReducer
        cameraXHolder.rotation = SCNVector4Make(0, 1, 0, xRotationValue)
        
        let currY = cameraYHolder.rotation
        var yRotationValue = currY.w + directionToPan.y * speedReducer
        
        if yRotationValue < -0.90 {
            yRotationValue = -0.90
        }
        if yRotationValue > 0.60 {
            yRotationValue = 0.60
        }

        cameraYHolder.rotation = SCNVector4Make(1, 0, 0, yRotationValue)
//        print("camera rotation: \(xRotationValue)")
    }
    
    func getRotation() -> Float {
        return cameraXHolder.rotation.w
    }

//    func coolCamera() {
//        cameraStick.camera?.wantsDepthOfField = true
//        cameraStick.camera?.focusDistance = 5
//        cameraStick.camera?.fStop = 0.01
//        cameraStick.camera?.focalLength = 24
//    }
}

extension MainCamera: SetupNodesInterface {
    func setup() -> SCNNode {
        guard
            let camera = scene.rootNode.childNode(withName: "CameraStick", recursively: false),
            let cameraY = scene.rootNode.childNode(withName: "yHolder", recursively: true),
            let cameraX = scene.rootNode.childNode(withName: "xHolder", recursively: true)
        else {
            return SCNNode()
        }
        
        cameraStick = camera
        cameraYHolder = cameraY
        cameraXHolder = cameraX
        
        return cameraStick
    }
}
