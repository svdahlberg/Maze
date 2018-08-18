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
        guard let goalNode = game.goals.last?.component(ofType: SpriteComponent.self)?.node,
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
        let waitDuration = Double(game.numberOfMovesFromStartToGoal) * 0.2
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
        guard !hidden else { return }
        
        
        let mazeSolution = game.mazeSolution
        guard let firstRoom = mazeSolution.first,
            let firstRoomNode = mazeNode.roomNode(with: firstRoom) else { return }

        let node = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: 10))
        node.position = firstRoomNode.position
        mazeNode.addChild(node)
        
        let emitterNode = SKEmitterNode(fileNamed: "Paint")!
        emitterNode.targetNode = mazeNode
        node.addChild(emitterNode)
        
        
        
        let actions: [SKAction] = mazeSolution.compactMap {
            guard let roomNode = mazeNode.roomNode(with: $0) else { return nil }
            let moveAction = SKAction.move(to: roomNode.position, duration: 0.2)
            
            return SKAction.group([moveAction])
        }

        let sequence = SKAction.sequence(actions)
        
        node.run(sequence) {
            emitterNode.particleBirthRate = 0
        }
        
        
        
        
        
        
//        let linePath = CGMutablePath()
//        linePath.move(to: firstRoomNode.position)
//
//        for i in 0...mazeSolution.count - 1 {
//            guard let roomNode = mazeNode.roomNode(with: mazeSolution[i]) else { continue }
//
//            let point = roomNode.position
//            linePath.addLine(to: point)
//            linePath.move(to: point)
//
//        }
//
//        let lineShape = SKShapeNode()
//        lineShape.path = linePath
//        lineShape.lineCap = .round
//        lineShape.strokeColor = .green
//        lineShape.lineWidth = 2
//        mazeNode.addChild(lineShape)
        
        
    }
    
}
