//
//  HUDScene.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import CoreMotion
import SceneKit
import SpriteKit

final class HUDScene: SKScene {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
    }
}
