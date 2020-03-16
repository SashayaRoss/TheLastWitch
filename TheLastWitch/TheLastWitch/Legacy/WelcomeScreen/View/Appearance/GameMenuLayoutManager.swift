//
//  GameMenuLayoutManager.swift
//  TheLastWitch
//
//  Created by Aleksandra Kustra on 16/03/2020.
//  Copyright © 2020 Aleksandra Kustra. All rights reserved.
//

import UIKit

final class GameMenuLayoutManager {
    //passing bg image in init?
}

extension GameMenuLayoutManager: GameMenuLayoutManaging {
    func configure() -> GameMenuViewInterface {
        let view = GameMenuView()
        
        view.actionView.translatesAutoresizingMaskIntoConstraints = false
        view.newGameButton.translatesAutoresizingMaskIntoConstraints = false
        view.exitGameButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(view.actionView)
        view.actionView.addSubview(view.newGameButton)
        view.actionView.addSubview(view.exitGameButton)
        
        NSLayoutConstraint.activate([
            view.actionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            view.actionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            view.actionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150),
            view.actionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            
            view.newGameButton.topAnchor.constraint(equalTo: view.actionView.topAnchor, constant: 30),
            view.newGameButton.centerXAnchor.constraint(equalTo: view.actionView.centerXAnchor),
            view.newGameButton.widthAnchor.constraint(equalToConstant: 300),
            view.newGameButton.heightAnchor.constraint(equalToConstant: 50),
            
            view.exitGameButton.bottomAnchor.constraint(equalTo: view.actionView.bottomAnchor, constant: -30),
            view.exitGameButton.centerXAnchor.constraint(equalTo: view.actionView.centerXAnchor),
            view.exitGameButton.widthAnchor.constraint(equalToConstant: 300),
            view.exitGameButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
        view.backgroundColor = ColourBase().green()
        view.actionView.backgroundColor = ColourBase().viollet()
        view.newGameButton.backgroundColor = .blue
        view.exitGameButton.backgroundColor = .black
        
        
        
        
        return view
    }
    
}
