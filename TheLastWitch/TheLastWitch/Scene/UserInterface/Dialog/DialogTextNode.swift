//
//  DialogTextNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 28/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class DialogTextNode {
    private var dialogSprite: SKLabelNode!
    private var bounds: CGRect
    
    init(bounds: CGRect) {
        self.bounds = bounds
    }
    //wyświetlanie nowego tekstu
    func update(dialog: String) {
        dialogSprite.text = dialog
    }
}

extension DialogTextNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        //zainicjalizownaie węzła czcionką
        dialogSprite = SKLabelNode(fontNamed: "Menlo")
        //nadanie nazwy
        dialogSprite.name = "DialogTextNode"
        //ustalenie pozycji
        dialogSprite.position = CGPoint(x: 30, y: 130)
        //nadanie wielkości czcionki
        dialogSprite.fontSize = 14
        //wyrównanie tekstu
        dialogSprite.horizontalAlignmentMode = .left
        dialogSprite.verticalAlignmentMode = .top
        //nadanie maksymalnej wielkości do jakiej tekst wyświetli się w pojedynczej lini
        dialogSprite.preferredMaxLayoutWidth = bounds.size.width - 50
        //wyświetlanie tekstu w więcej niż jednej lini
        dialogSprite.numberOfLines = 2
        //nadanie koloru tekstu
        dialogSprite.fontColor = .brownLetters
    

        //dodanie do sceny
        scene.addChild(dialogSprite)
    }
}
