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
        
//        gameScene.game.player.addComponent(MovementIndicatorComponent(directions: gameScene.game.mazeNode.possibleDirectionsToTravelIn()))
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if gameScene.game.failingCondition {
            stateMachine?.enter(GameSceneFailState.self)
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameSceneSuccessState.Type, is GameSceneFailState.Type:
            return true
        default:
            return false
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
        guard let playerSpriteComponent = player.component(ofType: SpriteComponent.self),
            playerSpriteComponent.shape == goal.component(ofType: SpriteComponent.self)?.shape else {
                print("Not the same shape")
                return
        }
        
        if let nextGoal = gameScene.game.unreachedGoals.first,
            let nextGoalShape = nextGoal.component(ofType: SpriteComponent.self)?.shape {
            playerSpriteComponent.shape = nextGoalShape
        }
        
        if gameScene.game.allGoalsReached {
            stateMachine?.enter(GameSceneSuccessState.self)
        }
    }
    
    func player(_ player: Player, didMoveIn direction: Direction) {
        gameScene.updateHud()
    }

}






