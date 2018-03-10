//
//  LevelTests.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-05.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Maze

class LevelTests: XCTestCase {
    
    // MARK: mazeDimensions
    
    func testMazeDimensions_withLevelOneShouldReturn4x4() {
        let level = Level(number: 1)
        let mazeDimensions = level.mazeDimensions
        XCTAssertEqual(mazeDimensions.rows, 4)
        XCTAssertEqual(mazeDimensions.columns, 4)
    }
    
    func testMazeDimensions_withLevelTwoShouldReturn6x6() {
        let level = Level(number: 2)
        let mazeDimensions = level.mazeDimensions
        XCTAssertEqual(mazeDimensions.rows, 6)
        XCTAssertEqual(mazeDimensions.columns, 6)
    }
    
}
