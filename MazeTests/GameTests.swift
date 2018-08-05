//
//  GameTests.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-05.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Maze
import GameplayKit

class GameTests: XCTestCase {
    
    private var sut: Game!
    
    private var playerMock: PlayerMock!
    
    override func setUp() {
        super.setUp()
        playerMock = PlayerMock()
        sut = Game(level: Level(number: 1), player: playerMock)
    }
    
    override func tearDown() {
        sut = nil
        playerMock = nil
        super.tearDown()
    }
    
    // MARK: mazeNode
    
    func testMazeNode_shouldReturnMazeNodeWithSameDimensionsAsLevel() {
        XCTAssertEqual(sut.mazeNode.maze.rows, sut.level.mazeDimensions.rows)
        XCTAssertEqual(sut.mazeNode.maze.columns, sut.level.mazeDimensions.columns)
    }
    
    // MARK: goals
    
    func testGoals_withMazeNodeWithTwoMoreDeadEndsThanGoalsInLevel_shouldReturnNumberOfGoalsInLevel() {
        sut = Game(level: LevelMock(number: 3, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        let goals = sut.goals
        XCTAssertEqual(goals.count, 3)
    }
    
    func testGoals_withMazeNodeWithSameDeadEndCountAsGoalsInLevel_shouldReturnOneLessGoalThanInLevel() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 3)
        let goals = sut.goals
        XCTAssertEqual(goals.count, 2)
    }
    
    func testGoals_withMazeNodeWithOnlyTwoDeadEnds_shouldReturnOneGoal() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 2)
        let goals = sut.goals
        XCTAssertEqual(goals.count, 1)
    }
    
    func testNumberOfGoals_shouldReturnCountOfGoals() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 4)
        XCTAssertEqual(sut.numberOfGoals, 3)
    }

    func testNumberOfReachedGoals_shouldReturnNumberOfGoalsWithPropertyReachedSetToTrue() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.goals.first?.reached = true
        XCTAssertEqual(sut.numberOfReachedGoals, 1)
    }
    
    func testAllGoalsReached_shouldReturnTrueIfAllGoalsHavePropertyReachedSetToTrue() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.goals.forEach { $0.reached = true }
        XCTAssertTrue(sut.allGoalsReached)
    }
    
    func testAllGoalsReached_shouldReturnFalseIfNotAllGoalsHavePropertyReachedSetToTrue() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.goals.first?.reached = true
        XCTAssertFalse(sut.allGoalsReached)
    }
    
    // MARK: placePlayerInMaze
    
    func testPlacePlayerInMaze_shouldSetPositionOfPlayerToPositionOfCurrentRoomOfMaze() {
        sut.placePlayerInMaze()
        let currentRoomOfMaze = sut.mazeNode.currentRoom
        let firstRoomOfMazePosition = sut.mazeNode.position(forRoom: currentRoomOfMaze)
        let playerNode = sut.player.component(ofType: SpriteComponent.self)?.node
        let playerPosition = playerNode?.position
        XCTAssertEqual(playerPosition, firstRoomOfMazePosition)
    }
    
    func testPlacePlayerInMaze_shouldAddPlayerNodeAsChildOfMazeNode() {
        sut.placePlayerInMaze()
        let playerNode = sut.player.component(ofType: SpriteComponent.self)!.node
        XCTAssertTrue(sut.mazeNode.children.contains(playerNode))
    }
    
    func testPlacePlayerInMaze_shouldAddPlayerToEntities() {
        sut.placePlayerInMaze()
        let player = sut.player
        XCTAssertTrue(sut.entities.contains(player))
    }
    
    // MARK: placeGoalsInMaze
    
    func testPlaceGoalsInMaze_shouldSetPositionOfGoalsToPositionOfTheRoomPropertyOnTheGoal() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.placeGoalsInMaze()
        for goal in sut.goals {
            let goalNode = goal.component(ofType: SpriteComponent.self)?.node
            let goalPosition = sut.mazeNode.position(forRoom: goal.room)
            XCTAssertEqual(goalPosition, goalNode?.position)
        }
    }
    
    func testPlaceGoalsInMaze_shouldAddGoalNodesAsChildrenOfMazeNode() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.placeGoalsInMaze()
        for goal in sut.goals {
            let goalNode = goal.component(ofType: SpriteComponent.self)!.node
            XCTAssertTrue(sut.mazeNode.children.contains(goalNode))
        }
    }
    
    func testPlaceGoalsInMaze_shouldAddGoalsToEntities() {
        sut = Game(level: LevelMock(number: 1, numberOfGoals: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.placeGoalsInMaze()
        for goal in sut.goals {
            XCTAssertTrue(sut.entities.contains(goal))
        }
    }
    
    // MARK: numberOfMovesFromStartToGoal
    
    func testNumberOfMovesFromStartToGoal_withOneGoals_shouldReturnNumberOfRoomsInPathFromPlayerStartingRoomToGoalRoom() {
        let mazeSolverMock = MazeSolverMock()
        sut.mazeSolvers = [mazeSolverMock]
        XCTAssertEqual(sut.numberOfMovesFromStartToGoal, mazeSolverMock.solve()?.rooms().count)
    }
    
    
    // MARK: numberOfMovesLeft
    
    func testNumberOfMovesLeft_withNumberOfMovesByPlayerZero_shouldReturnNumberOfMovesFromStartToGoal() {
        let mazeSolverMock = MazeSolverMock()
        sut.mazeSolvers = [mazeSolverMock]
        XCTAssertEqual(sut.numberOfMovesLeft, mazeSolverMock.solve()?.rooms().count)
    }
    
    func testNumberOfMovesLeft_withNumberOfMovesByPlayerNotZero_shouldReturnNumberOfMovesFromStartToGoalMinusNumberOFMovesMadeByPlayer() {
        let mazeSolverMock = MazeSolverMock()
        sut.mazeSolvers = [mazeSolverMock]
        playerMock._numberOfMovesMade = 1
        XCTAssertEqual(sut.numberOfMovesLeft, (mazeSolverMock.solve()?.rooms().count)! - playerMock.numberOfMovesMade)
    }
}

class PlayerMock: Player {
    
    var _numberOfMovesMade: Int = 0
    
    override var numberOfMovesMade: Int { return _numberOfMovesMade }
    
}
