//
//  GameSceneOverlayState.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-09-11.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneOverlayState: GKState {
    
    unowned let gameScene: GameScene
    
    var overlay: SceneOverlay!
    var overlaySceneFileName: String { fatalError("Unimplemented overlaySceneName") }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        super.init()
        
        overlay = SceneOverlay(overlaySceneFileName: overlaySceneFileName, zPosition: 1000)
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        gameScene.overlay = overlay
        
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        gameScene.overlay = nil
        
    }
    
}


