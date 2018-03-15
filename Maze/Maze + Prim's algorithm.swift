//
//  Maze + Prim's algorithm.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-15.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

extension Maze {
    
    func removeWallsUsingPrimsAlgorithm() {
        let initialRoom = randomRoom()
        var maze = [initialRoom]
        var frontier = adjacentRooms(of: initialRoom)
        
        while !frontier.isEmpty {
            let nextRoom = frontier.randomElement()
            let adjacentRoomsOfNextRoom = adjacentRooms(of: nextRoom)
            let adjacentRoomInMaze = adjacentRoomsOfNextRoom
                .filter { maze.contains($0) }
                .randomElement()
            
            removeWall(between: nextRoom, and: adjacentRoomInMaze)
            maze.append(nextRoom)
            frontier = frontier.filter { $0 != nextRoom }
            let adjacentRoomsNotInFrontierOrMaze = adjacentRoomsOfNextRoom.filter {
                !maze.contains($0) && !frontier.contains($0)
            }
            frontier.append(contentsOf: adjacentRoomsNotInFrontierOrMaze)
        }
    }
    
    func randomRoom() -> Room {
        return matrix[Int(arc4random_uniform(UInt32(columns - 1)))][Int(arc4random_uniform(UInt32(rows - 1)))]
    }
    
}

extension Array {
    
    func randomElement() -> Element {
        return self[Int(arc4random_uniform(UInt32(count - 1)))]
    }
    
}
