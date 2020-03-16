//
//  GameMenuController.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 15/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit
import SpriteKit

final class GameMenuController: UIViewController {
    private let layoutManager: GameMenuLayoutManaging
    
    private lazy var menuView = layoutManager.configure()
    
    init(layoutManager: GameMenuLayoutManaging) {
        self.layoutManager = layoutManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.newGameButton.setTitle("NEW GAME", for: .normal)
        menuView.newGameButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        
        menuView.exitGameButton.setTitle("EXIT", for: .normal)
        menuView.exitGameButton.addTarget(self, action: #selector(exitGame), for: .touchUpInside)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func exitGame() {
        print("exit")
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
    
    @objc func startNewGame() {
        view = GameView()
        print("startNewGame")
//        let vc = GameViewConfigurator().configure()
//        self.present(vc, animated: true, completion: nil)
    }
}
