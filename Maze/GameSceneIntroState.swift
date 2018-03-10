//
//  GameSceneIntroState.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-10.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneIntroState: GKState {
    
    unowned let gameScene: GameScene
    
    private lazy var game = gameScene.game
    private lazy var mazeNode = gameScene.game.mazeNode
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        gameScene.game.player.isControllable = false
        gameScene.isUserInteractionEnabled = false
        
        showGoalAndMap {
            self.stateMachine?.enter(GameSceneActiveState.self)
        }
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        gameScene.game.player.isControllable = true
        gameScene.isUserInteractionEnabled = true
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameSceneActiveState.Type: return true
        default: return false
        }
    }
    
    private func showGoalAndMap(completion: @escaping () -> Void) {
        guard let goal = game.goal,
            let goalNode = goal.component(ofType: SpriteComponent.self)?.node,
            let playerNode = game.player.component(ofType: SpriteComponent.self)?.node
            else { return }
        
        let goalPosition = gameScene.convert(goalNode.position, from: mazeNode)
        let playerPosition = gameScene.convert(playerNode.position, from: mazeNode)
        
        gameScene.playerCamera.position = goalPosition
        gameScene.playerCamera.setScale(gameScene.cameraScale)
        
        let zoomOutAction = SKAction.scale(to: 2, duration: 2)
        zoomOutAction.timingMode = .easeOut
        let moveToPlayerAction = SKAction.move(to: playerPosition, duration: 3)
        moveToPlayerAction.timingMode = .easeInEaseOut
        let zoomInAction = SKAction.scale(to: gameScene.cameraScale, duration: 1)
        zoomInAction.timingMode = .easeIn
        
        let lightNode = SKLightNode()
        gameScene.playerCamera.addChild(lightNode)
        let path = MazeSolver(maze: mazeNode.maze, start: goal.room, end: mazeNode.maze.currentRoom).solve()
        let roomPath = path!.rooms()
        let positionPath = roomPath.map { mazeNode.position(forRoom: $0) }
        
        var previousPoint = goalPosition
        let pathActions = positionPath.map { (position: CGPoint) -> SKAction in
            let point = gameScene.convert(position, from: mazeNode)
            let action = SKAction.move(to: point, duration: TimeInterval.duration(toMoveFrom: previousPoint, to: point, with: 200))
            previousPoint = point
            return action
        }
        
        let actionSequence = SKAction.sequence([zoomOutAction, SKAction.sequence(pathActions), zoomInAction])
        
        gameScene.playerCamera.run(actionSequence) {
            lightNode.removeFromParent()
            completion()
        }
    }
}
