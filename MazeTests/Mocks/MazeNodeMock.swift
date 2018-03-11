//
//  MazeNodeMock.swift
//  MazeTests
//
//  Created by Svante Dahlberg on 2018-03-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreGraphics
@testable import Maze

class MazeNodeMock: MazeNode {
    
    private let numberOfDeadEnds: Int
    
    init(numberOfDeadEnds: Int) {
        self.numberOfDeadEnds = numberOfDeadEnds
        super.init(color: .clear, roomSize: CGSize(width: 1, height: 1), dimensions: MazeDimensions(rows: 5, columns: 5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deadEnds() -> [Room]? {
        var rooms = [Room]()
        for i in 1...numberOfDeadEnds {
            rooms.append(Room(x: i, y: i))
        }
        
        return rooms.isEmpty ? nil : rooms
    }
}
