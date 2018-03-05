//
//  TimeIntervalExtensionsTests.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-05.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Maze

class TimeIntervalExtensionsTests: XCTestCase {
    
    func testDurationToMoveFromPointAToPointBReturnsTheDistanceTraveledDividedByTheSpeed() {
        let pointA = CGPoint(x: 1, y: 1)
        let pointB = CGPoint(x: 2, y: 1)
        let speed: CGFloat = 1
        let time = TimeInterval.duration(toMoveFrom: pointA, to: pointB, with: speed)
        XCTAssertEqual(1, time)
    }
    
    func testDurationToMoveFromPointAToPointB_withSpeedZero_returnsInfinity() {
        let pointA = CGPoint(x: 1, y: 1)
        let pointB = CGPoint(x: 2, y: 1)
        let speed: CGFloat = 0
        let time = TimeInterval.duration(toMoveFrom: pointA, to: pointB, with: speed)
        XCTAssertTrue(time.isInfinite)
    }
    
}
