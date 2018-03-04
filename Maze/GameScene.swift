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
    private var playerCamera: SKCameraNode!
    private let cameraScale: CGFloat = 0.25
    
    lazy var game: Game = Game(mazeNode: mazeNode)
    
    private lazy var mazeNode: MazeNode = {
        let mazeNode = MazeNode(color: .darkGray, roomSize: CGSize(width: 30, height: 30), dimensions: (cols: 3, rows: 3))
        mazeNode.position = CGPoint(x: size.height/2, y: size.height/2)
        return mazeNode
    }()
    
    private lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        GameSceneActiveState(game: game)
        ])
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        lastUpdateTime = 0
        backgroundColor = .black
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChild(mazeNode)
        setupPlayerControls()
        setupCamera()
        stateMachine.enter(GameSceneActiveState.self)
    }
    
    private func setupPlayerControls() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view?.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view?.addGestureRecognizer(swipeLeft)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        view?.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
    }
    
    private func setupCamera() {
        guard let playerNode = game.player.component(ofType: SpriteComponent.self)?.node else { return }
        playerCamera = SKCameraNode()
        playerCamera.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: playerNode)]
        playerCamera.setScale(cameraScale)
        addChild(playerCamera)
        camera = playerCamera
    }
    
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
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) -> Void {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right: game.player.move(inDirection: .right, inMazeNode: mazeNode)
        case UISwipeGestureRecognizerDirection.left: game.player.move(inDirection: .left, inMazeNode: mazeNode)
        case UISwipeGestureRecognizerDirection.up: game.player.move(inDirection: .up, inMazeNode: mazeNode)
        case UISwipeGestureRecognizerDirection.down: game.player.move(inDirection: .down, inMazeNode: mazeNode)
        default: break
        }
    }
}

