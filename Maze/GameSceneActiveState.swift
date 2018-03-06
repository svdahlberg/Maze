//
//  GameSceneActiveState.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//


import SpriteKit
import GameplayKit

class GameSceneActiveState: GKState {
    
    unowned let gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
        gameScene.game.player.delegate = self
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameSceneSuccessState.Type: return true
        default: return false
        }
    }
}

extension GameSceneActiveState: PlayerDelegate {
    func playerDidReachGoal(_ goal: Goal) {
        guard gameScene.game.allKeysCollected else {
            print("Need more keys")
            return
        }
        
        stateMachine?.enter(GameSceneSuccessState.self)
    }
    
    func playerDidCollectKey(_ key: Key) {
        print("Key collected")
    }
}






