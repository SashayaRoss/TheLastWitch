//
//  GameMenuViewInterface.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

protocol GameMenuViewInterface: UIView {
    var titleImage: UIImage { get }
    var actionView: UIView { get }
    var newGameButton: UIButton { get }
    var exitGameButton: UIButton { get }
}
