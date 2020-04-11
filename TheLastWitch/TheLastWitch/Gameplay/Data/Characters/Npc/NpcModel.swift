//
//  NpcModel.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 29/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

protocol NpcModel {
    var noticeDistance: Float { get }
    var dialog: [String] { get }
    var quest: Quest? { get }
    var model: String { get }
    var isInteracting: Bool { get set }
    
    func updateDialogWithQuest()
    func finishQuestDialogUpdate(quest: String)
}
