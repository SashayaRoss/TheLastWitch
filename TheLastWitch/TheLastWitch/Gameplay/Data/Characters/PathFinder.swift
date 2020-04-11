//
//  PathFinder.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 06/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class PathFinder {
    private let initialPos: SCNVector3
    private let destinationPos: SCNVector3
    private let dTour: SCNVector3?
    private let speed: Float
    
    init(
        initialPos: SCNVector3,
        destinationPos: SCNVector3,
        dTour: SCNVector3? = nil,
        speed: Float
    ) {
        self.initialPos = initialPos
        self.destinationPos = destinationPos
        self.dTour = dTour
        self.speed = speed
    }
    
    func move() {
        
    }
}
