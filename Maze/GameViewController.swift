//
//  GameViewController.swift
//  Maze
//
//  Created by Svante Dahlberg on 28/04/16.
//  Copyright (c) 2016 Svante Dahlberg. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let scene = HomeScene(fileNamed: "HomeScene") else { return }
//
////        let scene = GameScene(size: view.frame.size, level: Level(number: 1))
        guard let skView = self.view as? SKView else { return }
        skView.showsFPS = true
        skView.showsNodeCount = true
//
//        skView?.ignoresSiblingOrder = true
//
//        scene.scaleMode = .aspectFill
//        skView?.presentScene(scene)
        
        SceneManager(presentingView: skView).presentScene(with: .home)
        
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
