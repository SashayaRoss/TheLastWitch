//
//  FloatExtension.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

extension float2 {
    init(_ v: CGPoint) {
        self.init(Float(v.x), Float(v.y))
    }
}
