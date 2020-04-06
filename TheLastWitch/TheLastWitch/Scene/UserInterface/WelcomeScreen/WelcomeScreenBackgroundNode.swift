//
//  WelcomeScreenBackgroundNode.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 05/04/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import SceneKit
import SpriteKit
import AVFoundation

final class WelcomeScreenBackgroundNode {
    private var bounds: CGRect
    private var directory: String
    private let avPlayer: AVPlayer? = nil
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
    
    private var backgroundVideoNode: SKVideoNode? = {
        guard let urlString = Bundle.main.path(forResource: "art.scnassets/video", ofType: "mov") else {
            return nil
        }
        
        let url = URL(fileURLWithPath: urlString)
        let item = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: item)
        player.actionAtItemEnd = .none
//        avPlayer = player
        
        return SKVideoNode(avPlayer: player)
    }()
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
}

extension WelcomeScreenBackgroundNode: NodeProtocol {
    func setupNode(with scene: SKScene) {
        guard let node = backgroundVideoNode else { return }
        node.name = "VideoNode"
        node.position = CGPoint(x: bounds.midX, y: bounds.midY)
        node.size = CGSize(width: bounds.size.width, height: bounds.size.height)
       
        scene.addChild(node)
        node.play()
        
        
//        NotificationCenter.default.addObserver(
//            backgroundVideoNode,
//            selector: #selector(playerItemDidReachEnd),
//            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//            object: backgroundVideoNode.player.currentItem
//        )
    }
    
    //redundant??
    func virtualNodeBounds() -> CGRect {
        var virtualDialogBounds = CGRect(x: 10.0, y: 10.0, width: bounds.size.width - 20, height: 140)
        virtualDialogBounds.origin.y = bounds.size.height - virtualDialogBounds.size.height
        
        return virtualDialogBounds
    }
}
