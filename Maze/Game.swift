//
//  Game.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-03.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Game {
    
    private(set) var entities = Set<GKEntity>()
    
    lazy var mazeNode = MazeNode(color: .darkGray, roomSize: CGSize(width: 30, height: 30), dimensions: level.mazeDimensions)
    
    let player: Player
    
    let level: Level
    
    private(set) lazy var goal: Goal? = {
        guard let goalRoom = goalRoom else { return nil }
        return Goal(room: goalRoom)
    }()
    
    private(set) lazy var keys: [Key] = roomsWithKeys.map { Key(room: $0) }
    
    init(level: Level) {
        self.level = level
        self.player = Player()
    }
    
    var numberOfKeys: Int {
        return keys.count
    }
    
    var numberOfCollectedKeys: Int {
        return keys.filter { $0.collected }.count
    }
    
    var allKeysCollected: Bool {
        return !keys.contains { !$0.collected }
    }
    
    var failingCondition: Bool {
        return numberOfMovesLeft == 0
    }

    lazy var mazeSolver: MazeSolver? = {
        guard let goalRoom = goalRoom else { return nil }
        let mazeSolver = MazeSolver(maze: mazeNode.maze, start: playerStartingRoom, end: goalRoom)
        return mazeSolver
    }()
    
    var numberOfMovesLeft: Int? {
        guard let numberOfMovesFromStartToGoal = numberOfMovesFromStartToGoal else { return nil }
        return numberOfMovesFromStartToGoal - player.numberOfMovesMade
    }
    
    private(set) lazy var numberOfMovesFromStartToGoal: Int? = {
        let path = mazeSolver?.solve()
        return path?.rooms().count
    }()
    
    func update(with deltaTime: TimeInterval) {
        entities.forEach { $0.update(deltaTime: deltaTime) }
    }

    func placePlayerInMaze() {
        guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return }
        playerNode.position = mazeNode.position(forRoom: playerStartingRoom)
        mazeNode.addChild(playerNode)
        entities.insert(player)
    }
    
    func placeGoalInMaze() {
        guard let goal = goal,
            let goalNode = goal.component(ofType: SpriteComponent.self)?.node
            else { return }
        goalNode.position = mazeNode.position(forRoom: goal.room)
        mazeNode.addChild(goalNode)
        entities.insert(goal)
    }
    
    func placeKeysInMaze() {
        keys.forEach { key in
            if let keyNode = key.component(ofType: SpriteComponent.self)?.node {
                keyNode.position = mazeNode.position(forRoom: key.room)
                mazeNode.addChild(keyNode)
                entities.insert(key)
            }
        }
    }
    
    private var playerStartingRoom: Room {
        return mazeNode.maze.currentRoom
    }
    
    private var goalRoom: Room? {
        return mazeNode.deadEnds()?.last
    }
    
    private var roomsWithKeys: [Room] {
        guard let deadEnds = mazeNode.deadEnds() else { return [] }
        let possibleKeyRooms = Array(deadEnds.dropLast().dropFirst())
        return possibleKeyRooms[randomPick: level.numberOfKeys]
    }

}
