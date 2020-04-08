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
    
    init(bounds: CGRect, directory: String) {
        self.bounds = bounds
        self.directory = directory
    }
    
    private lazy var backgroundVideoNode: SKVideoNode? = {
        guard let urlString = Bundle.main.path(forResource: "art.scnassets/WelcomeScreen/video", ofType: "mov") else {
            return nil
        }
        
        let url = URL(fileURLWithPath: urlString)
        let item = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: item)
        player.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        return SKVideoNode(avPlayer: player)
    }()
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem = notification.object as? AVPlayerItem {
            print("replay")
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    func stopReplay() {
        backgroundVideoNode?.pause()
        backgroundVideoNode = nil
    }
}

extension WelcomeScreenBackgroundNode: NodeSetupInterface {
    func setupNode(with scene: SKScene) {
        guard let node = backgroundVideoNode else { return }
        node.name = "VideoNode"
        node.position = CGPoint(x: bounds.midX, y: bounds.midY)
        node.size = CGSize(width: bounds.size.width, height: bounds.size.height)
       
        scene.addChild(node)
        node.play()
    }
    
    //redundant??
    func virtualNodeBounds() -> CGRect {
        var virtualDialogBounds = CGRect(x: 10.0, y: 10.0, width: bounds.size.width , height: bounds.size.height)
        virtualDialogBounds.origin.y = bounds.size.height - virtualDialogBounds.size.height
        
        return virtualDialogBounds
    }
}
