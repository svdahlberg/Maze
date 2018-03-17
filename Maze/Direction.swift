//
//  Direction.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

enum Direction {
    case right, left, up, down
    
    static func direction(from wallPlacement: WallPlacement) -> Direction? {
        switch wallPlacement {
        case .right: return .right
        case .left: return .left
        case .top: return .up
        case .bottom: return .down
        case .outer: return nil
        }
    }
    
    var opposite: Direction {
        switch self {
        case .right: return .left
        case .left: return .right
        case .up: return .down
        case .down: return .up
        }
    }
    
    var positionChange: (x: Int, y: Int) {
        switch self {
        case .right: return (x: 1, y: 0)
        case .left: return (x: -1, y: 0)
        case .up: return (x: 0, y: -1)
        case .down: return (x: 0, y: 1)
        }
    }
    
}


