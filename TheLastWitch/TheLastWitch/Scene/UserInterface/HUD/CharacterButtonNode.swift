//
//  CharacterButtonNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit

final class CharacterButtonNode {
    private var characterButtonSprite: SKSpriteNode!
    private var bounds: CGRect
    private var size = 100.0
    private var directory: String
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
}

extension CharacterButtonNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        //zainicjalizowanie obiektu SKSpriteNode obrazkiem z podanej ścieżki
        characterButtonSprite = SKSpriteNode(imageNamed: directory + "avatar1Logo.png")
        //ustawienie pozycji na podstawie wielkości ekranu
        characterButtonSprite.position = CGPoint(x: 10, y: bounds.height - 105)
        //wyznaczenie skali
        characterButtonSprite.xScale = 1.0
        characterButtonSprite.yScale = 1.0
        //nadanie rozmiaru
        characterButtonSprite.size = CGSize(width: size, height: size)
        //ustawienie punktu zaczepienia
        characterButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        //nadanie nazwy
        characterButtonSprite.name = "attackButton"
        
        //dodanie do sceny
        scene.addChild(characterButtonSprite)
    }
}

extension CharacterButtonNode: VirtualBoundsSetupInterface {
    func virtualNodeBounds() -> CGRect {
        let virtualBounds = CGRect(
            x: 10.0,
            y: 10.0,
            width: size,
            height: size
        )
        
        return virtualBounds
    }
}
