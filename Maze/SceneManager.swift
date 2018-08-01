//
//  SceneManager.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-18.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import SpriteKit

enum SceneIdentifier {
    case home
    case game(Level)
    
    func scene(view: SKView) -> SKScene? {
        switch self {
        case .home:
            #if os(iOS)
                return HomeScene(fileNamed: "HomeScene")
            #elseif os(tvOS)
                return HomeScene(fileNamed: "HomeSceneTV")
            #endif
        case .game(let level):
            return GameScene(size: view.frame.size, level: level)
        }
    }
}

struct SceneManager {
    
    let presentingView: SKView
    
    func presentScene(with sceneIdentifier: SceneIdentifier, transition: SKTransition = .fade(withDuration: 0.5)) {
        guard let scene = sceneIdentifier.scene(view: presentingView) else { return }
        presentingView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFit
        presentingView.presentScene(scene, transition: transition)
    }
    
    
}
