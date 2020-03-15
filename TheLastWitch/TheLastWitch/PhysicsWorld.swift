//
//  PhysicsWorld.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
//
//final class PhysicsWorld() {
//    private let characterNode:
//    private let player: Player
//    
//    init() {
//        
//    }
//}
//
//extension PhysicsWorld: SCNPhysicsContactDelegate {
//    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
//        if gameState != .playing { return }
//        //if player collide with wall
//        contact.match(Bitmask().wall) {
//            (matching, other) in
//            self.characterNode(other, hitWall: matching, withContact: contact)
//        }
//        
//        // if player collides with enemy
//        contact.match(Bitmask().enemy) {
//            (matching, other) in
//            
//            let enemy = matching.parent as! Enemy
//            if other.name == "collider" { enemy.isCollidingWithEnemy = true }
//            if other.name == "weaponCollider" { player!.weaponCollide(with: enemy) }
//        }
//    }
//
//    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
//        //if player collide with wall
//        contact.match(Bitmask().wall) {
//            (matching, other) in
//            self.characterNode(other, hitWall: matching, withContact: contact)
//        }
//        // if player collides with enemy
//        contact.match(Bitmask().enemy) {
//            (matching, other) in
//            let enemy = matching.parent as! Enemy
//            if other.name == "collider" { enemy.isCollidingWithEnemy = true }
//            if other.name == "weaponCollider" { player!.weaponCollide(with: enemy) }
//        }
//    }
//
//    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
//        // if player collides with enemy
//        contact.match(Bitmask().enemy) {
//            (matching, other) in
//            let enemy = matching.parent as! Enemy
//            if other.name == "collider" { enemy.isCollidingWithEnemy = false }
//            if other.name == "weaponCollider" { player!.weaponUnCollide(with: enemy) }
//        }
//    }
//}
