//
//  NodeProtocol.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/12/2019.
//  Copyright © 2019 Aleksandra Kustra. All rights reserved.
//

import SpriteKit

protocol NodeProtocol {
    func setupNode(with scene: SKScene)
    func virtualNodeBounds() -> CGRect
}
