//
//  Maze + recursive backtracking.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-08-04.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

extension Maze {
    
    func removeWallsUsingRecursiveBacktracking() {
        var currentRoom = matrix[0][0]
        var roomStack = [currentRoom]
        var visitedRooms = [currentRoom]
        while !roomStack.isEmpty {
            var unvisitedAdjacentRooms = [Room]()
            for room in adjacentRooms(of: currentRoom) {
                if !visitedRooms.contains(room) {
                    unvisitedAdjacentRooms.append(room)
                }
            }
            if !unvisitedAdjacentRooms.isEmpty {
                let nextRoom = unvisitedAdjacentRooms[Int(arc4random_uniform(UInt32(unvisitedAdjacentRooms.count)))]
                roomStack.append(nextRoom)
                
                removeWall(between: currentRoom, and: nextRoom)
                
                currentRoom = nextRoom
                visitedRooms.append(currentRoom)
            } else {
                if let room = roomStack.popLast() {
                    currentRoom = room
                }
            }
        }
    }
}


