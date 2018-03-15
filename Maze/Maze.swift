//
//  Maze.swift
//  Maze
//
//  Created by Svante Dahlberg on 14/08/16.
//  Copyright © 2016 Svante Dahlberg. All rights reserved.
//

import Foundation

struct MazeDimensions {
    let rows: Int
    let columns: Int
}

class Maze {
    let dimensions: MazeDimensions
    var matrix: [[Room]]
    var currentRoom: Room
    
    var rows: Int { return dimensions.rows }
    var columns: Int { return dimensions.columns }
    
    init(dimensions: MazeDimensions) {
        self.dimensions = dimensions

        matrix = [[Room]](repeating: [Room](repeating: Room(x: 0, y: 0), count: dimensions.columns), count: dimensions.rows)
        for i in 0...dimensions.columns - 1 {
            for j in 0...dimensions.rows - 1 {
                matrix[i][j] = Room(x: i, y: j)
            }
        }

        currentRoom = matrix[0][0]

        createWalls()
//        removeWalls()
        removeWallsUsingPrimsAlgorithm()
    }

    func possibleDirectionsToTravelIn(from room: Room) -> [Direction] {
        let allWallPlacements: [WallPlacement] = [.right, .left, .top, .bottom]
        let wallPlacements = room.wallPlacements(in: self)
        let missingWallPlacements = Set(allWallPlacements).subtracting(wallPlacements)
        var possibleMovingDirections = [Direction]()
        missingWallPlacements.forEach {
            if let direction = Direction.direction(from: $0) {
                possibleMovingDirections.append(direction)
            }
        }

        return possibleMovingDirections
    }

    func nextStop(in direction: Direction, from room: Room) -> Room {
        var currentRoom = room
        switch direction {
        case .right:
            for col in room.x...rows - 1 {
                guard col + 1 < rows else { return currentRoom }
                let nextRoom = matrix[col + 1][room.y]
                if let roomToStopIn = roomToStopIn(currentRoom: currentRoom, nextRoom: nextRoom) {
                    return roomToStopIn
                }
                currentRoom = nextRoom
            }
        case .left:
            for col in (0...room.x).reversed() {
                guard col - 1 >= 0 else { return currentRoom }
                let nextRoom = matrix[col - 1][room.y]
                if let roomToStopIn = roomToStopIn(currentRoom: currentRoom, nextRoom: nextRoom) {
                    return roomToStopIn
                }
                currentRoom = nextRoom
            }

        case .down:
            for row in room.y...columns - 1 {
                guard row + 1 < columns else { return currentRoom }
                let nextRoom = matrix[room.x][row + 1]
                if let roomToStopIn = roomToStopIn(currentRoom: currentRoom, nextRoom: nextRoom) {
                    return roomToStopIn
                }
                currentRoom = nextRoom
            }
        case .up:
            for row in (0...room.y).reversed() {
                guard row - 1 >= 0 else { return currentRoom }
                let nextRoom = matrix[room.x][row - 1]
                if let roomToStopIn = roomToStopIn(currentRoom: currentRoom, nextRoom: nextRoom) {
                    return roomToStopIn
                }
                currentRoom = nextRoom
            }
        }

        return currentRoom
    }

    private func roomToStopIn(currentRoom: Room, nextRoom: Room) -> Room? {
        if let _ = wall(between: currentRoom, room2: nextRoom) {
            return currentRoom
        }
        if nextRoom.walls.count < 2 { return nextRoom }
        return nil
    }

    func wall(between room1: Room, room2: Room) -> Wall? {
        for wall1 in room1.walls {
            for wall2 in room2.walls {
                if wall1 == wall2 {
                    return wall1
                }
            }
        }
        return nil
    }

    func deadEnds() -> [Room]? {
        var deadEndedRooms = [Room]()
        for i in 0...rows - 1 {
            for j in 0...columns - 1 {
                let room = matrix[i][j]
                if room.walls.count > 2 {
                    deadEndedRooms.append(room)
                }
            }
        }
        return deadEndedRooms.count > 0 ? deadEndedRooms : nil
    }


    private func createWalls() {
        for row in 0...rows - 1 {
            for col in 0...columns - 1 {
                let room = matrix[row][col]
                for adjacentRoom in adjacentRooms(of: room) {
                    room.walls.append(Wall(room1: room, room2: adjacentRoom))
                }
                addOuterWalls(to: room, with: (col, row))
            }
        }
    }

    private func addOuterWalls(to room: Room, with coordinates: (col: Int, row: Int)) {
        let col = coordinates.col
        let row = coordinates.row
        if isOuterWall(col: col, row: row) {
            room.walls.append(Wall(room1: room, room2: nil))
            if isCornerWall(col: col, row: row) {
                room.walls.append(Wall(room1: room, room2: nil))
            }
        }
    }

    private func isOuterWall(col: Int, row: Int) -> Bool {
        return col == 0 || col == columns - 1 || row == 0 || row == rows - 1
    }

    private func isCornerWall(col: Int, row: Int) -> Bool {
        return (col == 0 && row == 0) ||
            (col == 0 && row == rows - 1) ||
            (col == columns - 1 && row == 0) ||
            (col == columns - 1 && row == rows - 1)
    }

    private func removeWalls() {
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
    
    func removeWall(between room1: Room, and room2: Room) {
        let wallToRemove = wall(between: room1, room2: room2)
        room1.walls = room1.walls.filter() { $0 != wallToRemove }
        room2.walls = room2.walls.filter() { $0 != wallToRemove }
    }

    func adjacentRooms(of room: Room) -> [Room] {
        var rooms = [Room]()
        if room.x + 1 < rows {
            rooms.append(matrix[room.x + 1][room.y])
        }
        if room.y + 1 < columns {
            rooms.append(matrix[room.x][room.y + 1])
        }
        if room.x - 1 >= 0 {
            rooms.append(matrix[room.x - 1][room.y])
        }
        if room.y - 1 >= 0 {
            rooms.append(matrix[room.x][room.y - 1])
        }
        return rooms
    }

    func printMatrix() {
        for row in matrix {
            for room in row {
                print()
                print("Room " + String(room.x) + "," + String(room.y))
                print(String(room.walls.count) + " walls")
                for wall in room.walls {
                    if let room1 = wall.room1, let room2 = wall.room2 {
                        print("Wall:")
                        print("Room 1: " + String(room1.x) + "," + String(room1.y))
                        print("Room 2: " + String(room2.x) + "," + String(room2.y))
                    }
                }
            }
        }
    }

}


