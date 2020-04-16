//
//  NpcCollider.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit

final class NpcCollider: ColliderInterface {
    var collider: SCNNode!

    func setupCollider(with scale: CGFloat) -> SCNNode {
        //wyznaczenie kształtu i wielkości figury
        let geometry = SCNCapsule(capRadius: 60, height: 200)
        //ustawienie jego koloru do testów
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        //stworzenie collider’a na bazie figury
        collider = SCNNode(geometry: geometry)
        //określenie pozycji, nazwy i widoczności
        collider.position = SCNVector3Make(0.0, 120, 0.0)
        collider.name = "npcCollider"
        collider.opacity = 0.0
        
        //skalowanie kształtu do wielkości obiektu na scenie
        let physicsGeometry = SCNCapsule(capRadius: 20 * scale, height: 52 * scale)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        //nadanie physicsBody
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        //nadanie obiektowi bitmaski
        collider.physicsBody!.categoryBitMask = Bitmask().npc
        //ustawienie które elementy przy zderzeniu będą wywoływać metodę physicsWorld(_:didBegin:)
        collider.physicsBody!.contactTestBitMask = Bitmask().wall | Bitmask().player | Bitmask().playerWeapon | Bitmask().enemy | Bitmask().magicElement
        
        return collider
    }
}
