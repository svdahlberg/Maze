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
        
        runIntroAnimation {
            self.stateMachine?.enter(GameSceneActiveState.self)
        }
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        gameScene.game.player.isControllable = true
        gameScene.isUserInteractionEnabled = true
        
        let lightComponent = LightComponent(lightCategory: .playerLight)
        gameScene.game.player.addComponent(lightComponent)
        
        toggleSolution(hidden: true)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameSceneActiveState.Type: return true
        default: return false
        }
    }
    
    private func runIntroAnimation(completion: @escaping () -> Void) {
        guard let goalNode = game.goal?.component(ofType: SpriteComponent.self)?.node,
            let playerNode = game.player.component(ofType: SpriteComponent.self)?.node
            else { return }
        
        let goalPosition = gameScene.convert(goalNode.position, from: mazeNode)
        let playerPosition = gameScene.convert(playerNode.position, from: mazeNode)
        let mazeCenterPosition = CGPoint(x: mazeNode.position.x + (mazeNode.frame.width / 2), y: mazeNode.position.y - (mazeNode.frame.height / 2))
        
        gameScene.playerCamera.position = goalPosition
        gameScene.playerCamera.setScale(gameScene.cameraScale)
        
        let zoomedOutScale = (mazeNode.size.width * 1.5) / gameScene.frame.width
        
        let zoomOutAction = SKAction.scale(to: zoomedOutScale, duration: 1)
        let moveToCenterAction = SKAction.move(to: mazeCenterPosition, duration: 1)
        moveToCenterAction.timingMode = .easeOut
        let waitDuration = Double(game.numberOfMovesFromStartToGoal ?? 0) * 0.2
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let moveToPlayerAction = SKAction.move(to: playerPosition, duration: 1)
        moveToPlayerAction.timingMode = .easeIn
        let zoomInAction = SKAction.scale(to: gameScene.cameraScale, duration: 1)
        zoomInAction.timingMode = .easeOut
        let showSolutionAction = SKAction.run { self.toggleSolution(hidden: false) }
        
        let actionSequence = SKAction.sequence([zoomOutAction, moveToCenterAction, showSolutionAction, waitAction, moveToPlayerAction, zoomInAction])
        
        gameScene.playerCamera.run(actionSequence) {
            completion()
        }
    }
    
    private func toggleSolution(hidden: Bool) {
        guard let mazeSolution = game.mazeSolution else { return }
        var actionDelay: TimeInterval = 0
        let actionInterval = 0.5 / Double(mazeSolution.count)
        
        for i in 0...mazeSolution.count - 1 {
            actionDelay += actionInterval
            guard let roomNode = mazeNode.roomNode(with: mazeSolution[i]) else { continue }
            let colorizeAction = SKAction.sequence(
                [SKAction.colorize(with: SKColor.gray, colorBlendFactor: 1, duration: 0.2),
                 SKAction.wait(forDuration: actionDelay),
                 SKAction.colorize(with: SKColor.white, colorBlendFactor: 1, duration: 0),
                 SKAction.colorize(with: SKColor.lightGray, colorBlendFactor: 1, duration: 0.3)]
            )
            let action = hidden ? colorizeAction.reversed() : colorizeAction
            roomNode.floorNode.run(action)
        }
    }
    
}
