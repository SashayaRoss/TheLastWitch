//
//  ColliderInterface.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

protocol ColliderInterface {
    var collider: SCNNode! { get set }
    func setupCollider(with scale: CGFloat) -> SCNNode
}
