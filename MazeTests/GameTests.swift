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
    
    override func setUp() {
        super.setUp()
        sut = Game(level: Level(number: 1))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: mazeNode
    
    func testMazeNode_shouldReturnMazeNodeWithSameDimensionsAsLevel() {
        XCTAssertEqual(sut.mazeNode.maze.rows, sut.level.mazeDimensions.rows)
        XCTAssertEqual(sut.mazeNode.maze.columns, sut.level.mazeDimensions.columns)
    }
    
    // MARK: goal
    
    func testGoal_withMazeNode_shouldReturnGoalWithRoomThatIsTheLastOfTheDeadEndsOfMazeNode() {
        let goal = sut.goal
        let lastDeadEndInMaze = sut.mazeNode.deadEnds()?.last
        XCTAssertEqual(goal?.room, lastDeadEndInMaze)
    }
    
    // MARK: keys
    
    func testKeys_withMazeNodeWithTwoMoreDeadEndsThanKeysInLevel_shouldReturnNumberOfKeysInLevel() {
        sut = Game(level: LevelMock(number: 3, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        let keys = sut.keys
        XCTAssertEqual(keys.count, 3)
    }
    
    func testKeys_withMazeNodeWithOneMoreDeadEndThanKeysInLevel_shouldReturnOneLessKeyThanInLevel() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 4)
        let keys = sut.keys
        XCTAssertEqual(keys.count, 2)
    }
    
    func testKeys_withMazeNodeWithOnlyTwoDeadEnds_shouldReturnZeroKeys() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 2)
        let keys = sut.keys
        XCTAssertEqual(keys.count, 0)
    }
    
    func testNumberOfKeys_shouldReturnCountOfKeys() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 4)
        XCTAssertEqual(sut.numberOfKeys, 2)
    }

    func testNumberOfCollectedKeys_shouldReturnNumberOfKeysWithPropertyCollectedSetToTrue() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.keys.first?.collected = true
        XCTAssertEqual(sut.numberOfCollectedKeys, 1)
    }
    
    func testAllKeysCollected_shouldReturnTrueIfAllKeysHavePropertyCollectedSetToTrue() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.keys.forEach { $0.collected = true }
        XCTAssertTrue(sut.allKeysCollected)
    }
    
    func testAllKeysCollected_shouldReturnFalseIfNotAllKeysHavePropertyCollectedSetToTrue() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.keys.first?.collected = true
        XCTAssertFalse(sut.allKeysCollected)
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
    
    // MARK: placeGoalInMaze
    
    func testPlaceGoalInMaze_shouldSetPositionOfGoalToPositionOfLastDeadEndOfMaze() {
        sut.placeGoalInMaze()
        let lastDeadEnd = sut.mazeNode.deadEnds()!.last!
        let lastDeadEndPosition = sut.mazeNode.position(forRoom: lastDeadEnd)
        let goalNode = sut.goal!.component(ofType: SpriteComponent.self)?.node
        let goalPosition = goalNode?.position
        XCTAssertEqual(goalPosition, lastDeadEndPosition)
    }
    
    func testPlaceGoalInMaze_shouldAddGoalNodeAsChildOfMazeNode() {
        sut.placeGoalInMaze()
        let goalNode = sut.goal!.component(ofType: SpriteComponent.self)!.node
        XCTAssertTrue(sut.mazeNode.children.contains(goalNode))
    }
    
    func testPlaceGoalInMaze_shouldAddGoalToEntities() {
        sut.placeGoalInMaze()
        let goal = sut.goal!
        XCTAssertTrue(sut.entities.contains(goal))
    }
    
    // MARK: placeKeysInMaze
    
    func testPlaceKeysInMaze_shouldSetPositionOfKeysToPositionOfTheRoomPropertyOnTheKey() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.placeKeysInMaze()
        for key in sut.keys {
            let keyNode = key.component(ofType: SpriteComponent.self)?.node
            let keyPosition = sut.mazeNode.position(forRoom: key.room)
            XCTAssertEqual(keyPosition, keyNode?.position)
        }
    }
    
    func testPlaceKeysInMaze_shouldAddKeyNodesAsChildrenOfMazeNode() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.placeKeysInMaze()
        for key in sut.keys {
            let keyNode = key.component(ofType: SpriteComponent.self)!.node
            XCTAssertTrue(sut.mazeNode.children.contains(keyNode))
        }
    }
    
    func testPlaceKeysInMaze_shouldAddKeysToEntities() {
        sut = Game(level: LevelMock(number: 1, numberOfKeys: 3))
        sut.mazeNode = MazeNodeMock(numberOfDeadEnds: 5)
        sut.placeKeysInMaze()
        for key in sut.keys {
            XCTAssertTrue(sut.entities.contains(key))
        }
    }
    
    
}
