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
    
    var overlay: OverlayNode!
    var overlaySceneFileName: String { fatalError("Unimplemented overlaySceneName") }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        super.init()
        
        overlay = OverlayNode(overlaySceneFileName: overlaySceneFileName, zPosition: 1000)
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        gameScene.overlay = overlay
        
        gameScene.game.player.isControllable = false
        gameScene.isUserInteractionEnabled = false
        
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        gameScene.overlay = nil
        
        gameScene.game.player.isControllable = true
        gameScene.isUserInteractionEnabled = true
        
    }
    
}


