//
//  Room.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-06.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

class Room: Equatable {
    let x: Int
    let y: Int
    var walls: [Wall]
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        walls = [Wall]()
    }
    
    var outerWalls: [Wall] {
        return walls.filter { $0.room1 == nil || $0.room2 == nil }
    }
    
    var isOuterRoom: Bool {
        return outerWalls.count == 1
    }
    
    var isCornerRoom: Bool {
        return outerWalls.count == 2
    }
    
    func wallPlacementForOuterWall(in maze: Maze) -> WallPlacement? {
        if x == 0 {
            return .left
        }
        if y == 0 {
            return .top
        }
        else if x == maze.width - 1 {
            return .right
        }
        else if y == maze.height - 1 {
            return .bottom
        }
        return nil
    }
    
    func wallPlacementsForCornerRoom(in maze: Maze) -> [WallPlacement] {
        if x == 0, y == 0 {
            return [.left, .top]
        }
        if x == maze.width - 1, y == 0 {
            return [.top, .right]
        }
        if x == 0, y == maze.height - 1 {
            return [.left, .bottom]
        }
        if x == maze.width - 1, y == maze.height - 1 {
            return [.bottom, .right]
        }
        return []
    }
    
    func wallPlacements(in maze: Maze) -> [WallPlacement] {
        var wallPlacements = walls.map { $0.wallPlacement }.filter { $0 != .outer }
        if isCornerRoom {
            wallPlacements.append(contentsOf: wallPlacementsForCornerRoom(in: maze))
        } else if isOuterRoom, let outerWallPlacement = wallPlacementForOuterWall(in: maze) {
            wallPlacements.append(outerWallPlacement)
        }
        
        return wallPlacements
    }
}

func ==(lhs: Room, rhs: Room) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}


