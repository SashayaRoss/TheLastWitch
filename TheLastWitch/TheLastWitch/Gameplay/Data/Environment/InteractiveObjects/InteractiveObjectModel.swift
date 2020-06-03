//
//  InteractiveObjectModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

protocol InteractiveObjectModel {
    var exp: Int { get }
    var dialog: [String] { get set }
    var perk: Perk { get set }
    var model: String { get }
    var noticeDistance: Float { get }
    var type: TargetType? { get }
    func resetModel()
}