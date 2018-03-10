//
//  MazeSolverTests.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-04.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Maze

class MazeSolverTests: XCTestCase {
    
    func testSolveReturnsPathToTravelInToSolveTheMaze() {
        let maze = Maze(dimensions: MazeDimensions(rows: 2, columns: 2))
        let startRoom = maze.matrix[0][0]
        let endRoom = maze.matrix[1][1]
        let mazeSolver = MazeSolver(maze: maze, start: startRoom, end: endRoom)
        let path = mazeSolver.solve()!
        let rooms = path.rooms()
        let directions = path.directions()
        XCTAssertEqual(rooms.count, 3)
        XCTAssertEqual(directions.count, 2)
    }
    
}
