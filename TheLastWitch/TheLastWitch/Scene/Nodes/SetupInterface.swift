//
//  SetupInterface.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

protocol SetupInterface {
    var scene: SCNScene { get }
    func setup()
}

protocol SetupNodesInterface {
    var scene: SCNScene { get }
    func setup() -> SCNNode
}
