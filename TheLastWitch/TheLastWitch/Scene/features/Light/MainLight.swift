//
//  MainLight.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class MainLight {
    var scene: SCNScene
    private var lightStick: SCNNode!
    
    init(scene: SCNScene) {
        self.scene = scene
    }
}

extension MainLight: SetupNodesInterface {
    func setup() -> SCNNode {
        lightStick = scene.rootNode.childNode(withName: "LightStick", recursively: false)!
        return lightStick
    }
}
