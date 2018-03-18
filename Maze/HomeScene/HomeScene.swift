//
//  HomeScene.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-18.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import SpriteKit

class HomeScene: BaseScene {
    
    private lazy var startButton: ButtonNode? = childNode(withName: "StartButton") as? ButtonNode
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        startButton?.action = { [weak self] () in
            self?.startGame()
        }
        
    }
    
    private func startGame() {
        guard let view = view else { return }
        SceneManager(presentingView: view).presentScene(with: .game(Level(number: 1)))
    }
    
    
}
