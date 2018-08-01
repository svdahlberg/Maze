//
//  GameViewController.swift
//  Maze tvOS
//
//  Created by Svante Dahlberg on 2018-07-29.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let skView = self.view as? SKView else { return }
        skView.showsFPS = true
        skView.showsNodeCount = true
        SceneManager(presentingView: skView).presentScene(with: .home)
    }
    
}

extension GameViewController {
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        guard let scene = (view as? SKView)?.scene else { return [] }
        return [scene]
    }
    
}
