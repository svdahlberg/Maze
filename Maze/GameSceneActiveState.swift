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
    
    var allKeysCollected: Bool {
        guard let keys = gameScene.keys else { return true }
        return !keys.contains { key in
            return !key.collected
        }
    }
    
    init(gameScene: GameScene, player: Player) {
        self.gameScene = gameScene
        super.init()
        player.delegate = self
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        default:
            return false
        }
    }
}

extension GameSceneActiveState: PlayerDelegate {
    func playerDidReachGoal(_ goal: Goal) {
        guard allKeysCollected else {
            print("Need more keys")
            // update UI
            return
        }
        print("Success")
        // Move to success state
    }
    
    func playerDidCollectKey(_ key: Key) {
        print("Key collected")
        // update UI
    }
}






