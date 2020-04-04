//
//  NpcModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

protocol NpcModel {
    var isInteracting: Bool { get set}
    var noticeDistance: Float { get }
    var dialog: [String] { get }
}
