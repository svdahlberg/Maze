//
//  Level.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-05.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

class Level {
    
    let number: Int
    
    init(number: Int) {
        self.number = number
    }
    
    var mazeDimensions: MazeDimensions {
        return MazeDimensions(rows: number * 2 + 2, columns: number  * 2 + 2)
    }
    
    var numberOfKeys: Int {
       return 0
    }
    
}
