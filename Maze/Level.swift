//
//  Level.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-05.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

struct Level {
    let number: Int
    
    var mazeDimensions: (rows: Int, columns: Int) {
        return (rows: number + 2, columns: number + 2)
    }
    
}
