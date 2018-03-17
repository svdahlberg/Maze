//
//  MazeSolver.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-04.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation


class MazeSolver {
    
    let maze: Maze
    let start: Room
    let end: Room
    
    init(maze: Maze, start: Room, end: Room) {
        self.maze = maze
        self.start = start
        self.end = end
    }
    
    func solve(skipCorridorsInSolution: Bool = true) -> Path? {
        var frontier = [Path(to: start)]
        var visitedRooms = [Room]()
        
        while !frontier.isEmpty {
            let currentPath = frontier.removeLast()
            
            guard !visitedRooms.contains(currentPath.room) else { continue }
            
            guard currentPath.room != end else { return currentPath }
            
            visitedRooms.append(currentPath.room)
            
            for direction in maze.possibleDirectionsToTravelIn(from: currentPath.room) {
                let nextRoom = skipCorridorsInSolution ?
                    maze.nextStop(in: direction, from: currentPath.room) :
                    maze.room(in: direction, of: currentPath.room)
                guard !visitedRooms.contains(nextRoom) else { continue }
                frontier.append(Path(to: nextRoom, directionTraveledIn: direction, previousPath: currentPath))
            }

        }
        
        return nil
    }
    
}


class Path {
    
    let room: Room
    let directionTraveledIn: Direction?
    let previousPath: Path?
    
    init(to room: Room, directionTraveledIn: Direction? = nil, previousPath: Path? = nil) {
        self.room = room
        self.directionTraveledIn = directionTraveledIn
        self.previousPath = previousPath
    }
    
    func rooms(accumulatedRooms: [Room] = []) -> [Room] {
        var accumulatedRooms = accumulatedRooms
        accumulatedRooms.append(room)
        guard let previousPath = previousPath else {
            return accumulatedRooms.reversed()
        }
        return previousPath.rooms(accumulatedRooms: accumulatedRooms)
    }
    
    func directions(accumulatedDirections: [Direction] = []) -> [Direction] {
        var accumulatedDirections = accumulatedDirections
        guard let directionTraveledIn = directionTraveledIn,
            let previousPath = previousPath else {
            return accumulatedDirections.reversed()
        }
        
        accumulatedDirections.append(directionTraveledIn)
        
        return previousPath.directions(accumulatedDirections: accumulatedDirections)
    }
    
}

