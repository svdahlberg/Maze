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
    
    lazy var mazeNode = MazeNode(color: Appearance.mazeFloorColor, roomSize: CGSize(width: 30, height: 30), dimensions: level.mazeDimensions)
    
    let player: Player
    
    let level: Level
    
    private(set) lazy var goals: [Goal] = roomsWithGoals.enumerated().map { (index, room) in
        guard index != 0 else {
            return Goal(room: room, shape: .circle)
        }
        return Goal(room: room, shape: Shape.random())
    }
    
    init(level: Level, player: Player = Player()) {
        self.level = level
        self.player = player
    }
    
    var numberOfGoals: Int {
        return goals.count
    }
    
    var numberOfReachedGoals: Int {
        return goals.filter { $0.reached }.count
    }
    
    var unreachedGoals: [Goal] {
        return goals.filter { !$0.reached }
    }
    
    var allGoalsReached: Bool {
        return !goals.contains { !$0.reached }
    }
    
    var failingCondition: Bool {
        return numberOfMovesLeft == 0
    }

    lazy var mazeSolvers: [MazeSolver] = {
        var start = playerStartingRoom
        var mazeSolvers = [MazeSolver]()
        goals.forEach {
            mazeSolvers.append(MazeSolver(maze: mazeNode.maze, start: start, end: $0.room))
            start = $0.room
        }
        
        return mazeSolvers
    }()
    
    lazy var mazeSolution: [Room] = {
        return mazeSolvers
            .reversed()
            .compactMap { $0.solve(skipCorridorsInSolution: false)?.rooms().reversed() }
            .flatMap{ $0 }
    }()
    
    var numberOfMovesLeft: Int {
        return numberOfMovesFromStartToGoal - player.numberOfMovesMade
    }
    
    private(set) lazy var numberOfMovesFromStartToGoal: Int = {
        return mazeSolvers
            .compactMap { $0.solve(skipCorridorsInSolution: true)?.rooms() }
            .flatMap { $0 }
            .count
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
    
    func placeGoalsInMaze() {
        goals.forEach { goal in
            if let goalNode = goal.component(ofType: SpriteComponent.self)?.node {
                goalNode.position = mazeNode.position(forRoom: goal.room)
                mazeNode.addChild(goalNode)
                entities.insert(goal)
            }
        }
    }
    
    private var playerStartingRoom: Room {
        return mazeNode.maze.currentRoom
    }
    
    private var roomsWithGoals: [Room] {
        guard let deadEnds = mazeNode.deadEnds() else { return [] }
        let possibleGoalRooms = Array(deadEnds.dropFirst())
        return Array(possibleGoalRooms.suffix(level.numberOfGoals))
    }

}
