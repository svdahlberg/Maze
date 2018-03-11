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
        
        setupPlayerCamera()
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
    
    private func setupPlayerCamera() {
        guard let playerNode = gameScene.game.player.component(ofType: SpriteComponent.self)?.node else { return }
        gameScene.playerCamera.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: playerNode)]
        gameScene.playerCamera.setScale(gameScene.cameraScale)
    }
}

extension GameSceneActiveState: PlayerDelegate {
    
    func player(_ player: Player, didReach goal: Goal) {
        guard gameScene.game.allKeysCollected else {
            print("Need more keys")
            return
        }
        
        stateMachine?.enter(GameSceneSuccessState.self)
    }
    
    func player(_ player: Player, didCollect key: Key) {
        print("Key collected")
    }
    
    func player(_ player: Player, didMoveIn direction: Direction) {
        gameScene.updateHud()
    }

}






