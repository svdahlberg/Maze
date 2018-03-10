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
    
    // MARK: init
    
    func testInit_shouldSetPositionOfPlayerToPositionOfCurrentRoomOfMaze() {
        let currentRoomOfMaze = sut.mazeNode.currentRoom
        let firstRoomOfMazePosition = sut.mazeNode.position(forRoom: currentRoomOfMaze)
        let playerNode = sut.player.component(ofType: SpriteComponent.self)?.node
        let playerPosition = playerNode?.position
        XCTAssertEqual(playerPosition, firstRoomOfMazePosition)
    }
    
    func testInit_shouldAddPlayerNodeAsChildOfMazeNode() {
        let playerNode = sut.player.component(ofType: SpriteComponent.self)!.node
        XCTAssertTrue(sut.mazeNode.children.contains(playerNode))
    }
    
    func testInit_shouldAddPlayerToEntities() {
        let player = sut.player
        XCTAssertTrue(sut.entities.contains(player))
    }
    
    func testInit_shouldSetPositionOfGoalToPositionOfLastDeadEndOfMaze() {
        let lastDeadEnd = sut.mazeNode.deadEnds()!.last!
        let lastDeadEndPosition = sut.mazeNode.position(forRoom: lastDeadEnd)
        let goalNode = sut.goal!.component(ofType: SpriteComponent.self)?.node
        let goalPosition = goalNode?.position
        XCTAssertEqual(goalPosition, lastDeadEndPosition)
    }
    
    func testInit_shouldAddGoalNodeAsChildOfMazeNode() {
        let goalNode = sut.goal!.component(ofType: SpriteComponent.self)!.node
        XCTAssertTrue(sut.mazeNode.children.contains(goalNode))
    }
    
    func testInit_shouldAddGoalToEntities() {
        let goal = sut.goal!
        XCTAssertTrue(sut.entities.contains(goal))
    }
    
    
}



