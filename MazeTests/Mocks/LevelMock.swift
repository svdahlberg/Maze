//
//  LevelMock.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

@testable import Maze

class LevelMock: Level {
    
    private let numberOfKeysMock: Int
    
    init(number: Int, numberOfKeys: Int) {
        numberOfKeysMock = numberOfKeys
        super.init(number: number)
    }
    
    override var numberOfKeys: Int { return numberOfKeysMock }
}
