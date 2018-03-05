//
//  ArrayExtensionsTests.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-04.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Maze

class ArrayExtensionsTests: XCTestCase {
    
    func testRandomPickReturnsArrayWithCountN() {
        let array: [Int] = [1, 2, 3, 4, 5]
        let randomArray = array[randomPick: 3]
        XCTAssertEqual(3, randomArray.count)
    }
    
    func testRandomPick_withArrayCountLowerThanN_ReturnsArrayWithSameCountAsArray() {
        let array: [Int] = [1, 2]
        let randomArray = array[randomPick: 3]
        XCTAssertEqual(2, randomArray.count)
    }
    
    func testRandomPick_withEmptyArray_returnsEmptyArrayArray() {
        let array: [Int] = []
        let randomArray = array[randomPick: 3]
        XCTAssertEqual([], randomArray)
    }
    
    func testRandomPick_withArrayCountSameAsN_returnsArrayWithSameCountAsArray() {
        let array: [Int] = [1, 2, 3]
        let randomArray = array[randomPick: 3]
        XCTAssertEqual(3, randomArray.count)
    }
    
    func testRandomPickReturnsArrayWithoutDuplicates() {
        let array: [Int] = [1, 2, 3, 4, 5]
        let randomArray = array[randomPick: 3]
        XCTAssertEqual(3, randomArray.count)
        let uniqueArray = Array(Set(randomArray))
        XCTAssertEqual(3, uniqueArray.count)
    }
    
}
