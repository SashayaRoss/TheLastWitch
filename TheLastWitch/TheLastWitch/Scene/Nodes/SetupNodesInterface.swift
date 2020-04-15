//
//  SetupNodesInterface.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

protocol SetupNodesInterface {
    var scene: SCNScene { get }
    func setup() -> SCNNode
}
