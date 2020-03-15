//
//  AnimationInterface.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

protocol AnimationInterface {
    var walkAnimation: CAAnimation { get }
    var attackAnimation: CAAnimation { get }
    var deadAnimation: CAAnimation { get }
    var object: CAAnimation { get }
    
    func loadAnimations()
}
