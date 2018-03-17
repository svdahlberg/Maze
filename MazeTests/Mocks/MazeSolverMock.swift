//
//  MazeSolverMock.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Maze

class MazeSolverMock: MazeSolver {
    
    init() {
        super.init(maze: Maze(dimensions: MazeDimensions(rows: 3, columns: 3)), start: Room(x: 0, y: 0), end: Room(x: 0, y: 2))
    }
    
    override func solve(skipCorridorsInSolution: Bool = true) -> Path? {
        return PathMock()
    }
    
}

class PathMock: Path {
    
    init() {
        super.init(to: Room(x: 1, y: 1))
    }
    
    override func rooms(accumulatedRooms: [Room]) -> [Room] {
        return [
            Room(x: 0, y: 0),
            Room(x: 0, y: 1),
            Room(x: 0, y: 2)
        ]
    }
    
}
