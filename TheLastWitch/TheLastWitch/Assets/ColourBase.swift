//
//  ColourBase.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 01/02/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

final class ColourBase {
    let baseGreen: UIColor
    let baseViolet: UIColor
    
    init() {
        baseGreen = UIColor(red: 0.19, green: 0.54, blue: 0.09, alpha: 1.0)
        baseViolet = UIColor(red: 0.54, green: 0.18, blue: 0.09, alpha: 1.0)
        
    }
    
    func green() -> UIColor {
        return baseGreen
    }
    func viollet() -> UIColor {
        return baseViolet
    }
}

// create UIColour extension
//
//@objc public extension UIColor {
//    struct Colors {
//        let baseGreen = UIColor(red: 0.19, green: 0.54, blue: 0.09, alpha: 1.0)
//    }
//}
