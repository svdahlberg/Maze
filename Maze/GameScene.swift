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
    private var entities = Set<GKEntity>()
    private var lastUpdateTime: TimeInterval = 0
    private var mazeNode: MazeNode!
    private let player = Player()
    private var playerCamera: SKCameraNode!
    private let cameraScale: CGFloat = 0.25
    private let goal = Goal()
    
    var keys: [Key]?
    var numberOfKeys: Int {
        guard let keys = keys else { return 0 }
        return keys.count
    }
    
    var numberOfCollectedKeys: Int {
        guard let keys = keys else { return 0 }
        return keys.filter { $0.collected }.count
    }
    
    lazy var game: Game = {
        return Game(mazeNode: mazeNode)
    }()
    
    private lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        GameSceneActiveState(gameScene: self, player: self.player)
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
        createMaze()
        setupPlayerControls()
        setupCamera()
        stateMachine.enter(GameSceneActiveState.self)
    }
    
    private func createMaze() {
        mazeNode = MazeNode(color: .darkGray, roomSize: CGSize(width: 30, height: 30), dimensions: (cols: 10, rows: 10))
        mazeNode.position = CGPoint(x: size.height/2, y: size.height/2)
        addChild(mazeNode)
        placePlayerInMaze()
        placeGoalInMaze()
        placeKeysInMaze()
    }
    
    private func placePlayerInMaze() {
        guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return }
        playerNode.position = mazeNode.positionForCurrentRoom()
        mazeNode.addChild(playerNode)
        entities.insert(player)
    }
    
    private func placeGoalInMaze() {
        guard let goalNodeRoom = mazeNode.deadEnds()?.last else { return }
        guard let goalNode = goal.component(ofType: SpriteComponent.self)?.node else { return }
        goalNode.position = mazeNode.position(forRoom: goalNodeRoom)
        mazeNode.addChild(goalNode)
        entities.insert(goal)
    }
    
    private func placeKeysInMaze() {
        guard let deadEnds = mazeNode.deadEnds()?.dropLast().dropFirst()[randomPick: 3] else { return }
        keys = deadEnds.map { (room: Room) -> Key in
            let key = Key()
            if let keyNode = key.component(ofType: SpriteComponent.self)?.node {
                keyNode.position = mazeNode.position(forRoom: room)
                mazeNode.addChild(keyNode)
            }
            entities.insert(key)
            return key
        }
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
        guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return }
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
        entities.forEach { $0.update(deltaTime: dt) }
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
        case UISwipeGestureRecognizerDirection.right: player.move(inDirection: .right, inMazeNode: mazeNode)
        case UISwipeGestureRecognizerDirection.left: player.move(inDirection: .left, inMazeNode: mazeNode)
        case UISwipeGestureRecognizerDirection.up: player.move(inDirection: .up, inMazeNode: mazeNode)
        case UISwipeGestureRecognizerDirection.down: player.move(inDirection: .down, inMazeNode: mazeNode)
        default: break
        }
    }
}

