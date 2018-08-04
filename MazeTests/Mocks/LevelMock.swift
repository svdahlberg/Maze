//
//  LevelMock.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

@testable import Maze

class LevelMock: Level {
    
    private let numberOfGoalsMock: Int
    
    init(number: Int, numberOfGoals: Int) {
        numberOfGoalsMock = numberOfGoals
        super.init(number: number)
    }
    
    override var numberOfGoals: Int { return numberOfGoalsMock }
}
