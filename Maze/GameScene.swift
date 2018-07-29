//
//  GameScene.swift
//  Maze
//
//  Created by Svante Dahlberg on 28/04/16.
//  Copyright (c) 2016 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: BaseScene {
    private var lastUpdateTime: TimeInterval = 0
    var playerCamera: SKCameraNode
    let cameraScale: CGFloat = 0.25
    private let hudNode: HUDNode
    private let swipeControls: SwipeControls
    
    let game: Game
    
    init(size: CGSize, level: Level) {
        game = Game(level: level)
        playerCamera = SKCameraNode()
        hudNode = HUDNode(movesLeft: game.numberOfMovesFromStartToGoal)
        swipeControls = SwipeControls()
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var mazeNode: MazeNode { return game.mazeNode }
    
    private lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        GameSceneIntroState(gameScene: self),
        GameSceneActiveState(gameScene: self),
        GameSceneSuccessState(gameScene: self),
        GameSceneFailState(gameScene: self)
        ])
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        lastUpdateTime = 0
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        mazeNode.position = CGPoint(x: size.height/2, y: size.height/2)
        addChild(mazeNode)
        game.placePlayerInMaze()
        game.placeGoalInMaze()
        game.placeKeysInMaze()
        swipeControls.setup(on: view)
        swipeControls.delegate = self
        setupCamera()
        setupHUD()
        stateMachine.enter(GameSceneIntroState.self)
    }
 
    // MARK: Camera
    
    private func setupCamera() {
        addChild(playerCamera)
        camera = playerCamera
    }
    
    // MARK: HUD
    
    private func setupHUD() {
        playerCamera.addChild(hudNode)
        hudNode.updateScale()
    }
    
    func updateHud() {
        hudNode.movesLeft = game.numberOfMovesLeft
    }
    
    // MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if (lastUpdateTime == 0) {
            lastUpdateTime = currentTime
        }
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        game.update(with: dt)
        stateMachine.update(deltaTime: dt)
    }
    
    // MARK: Touch Input
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let force = touch.force/10
            if force > cameraScale, force < 1 {
                playerCamera.setScale(force)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { _ in playerCamera.setScale(cameraScale) }
    }
    
}

extension GameScene: SwipeControlsDelegate {
    func swipeControls(_ swipeControls: SwipeControls, didSwipeIn direction: Direction) {
        game.player.move(inDirection: direction)
    }
}
