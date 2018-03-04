//
//  MazeFactory.swift
//  Maze
//
//  Created by Svante Dahlberg on 14/08/16.
//  Copyright © 2016 Svante Dahlberg. All rights reserved.
//

import Foundation

class MazeFactory {
    
//    func createMaze(_ width: Int, height: Int) -> Maze {
//        let maze =  Maze(width: width, height: height)
////        createWalls(maze)
////        removeWalls(maze)
//        return maze
//    }
    
//    private func createWalls(_ maze: Maze) {
//        for row in 0...maze.width - 1 {
//            for col in 0...maze.height - 1 {
//                let room = maze.matrix[row][col]
//                for adjacentRoom in adjacentRooms(ofRoom: room, inMaze: maze) {
//                    room.walls.append(Wall(room1: room, room2: adjacentRoom))
//                }
//                addOuterWalls(toRoom: room, withCoordinates: (col, row), inMaze: maze)
//            }
//        }
//    }
//
//    private func addOuterWalls(toRoom room: Room, withCoordinates coordinates: (col: Int, row: Int), inMaze maze: Maze) {
//        let col = coordinates.col
//        let row = coordinates.row
//        if isOuterWall(col: col, row: row, maze: maze) {
//            room.walls.append(Wall(room1: room, room2: nil))
//            if isCornerWall(col: col, row: row, maze: maze) {
//                room.walls.append(Wall(room1: room, room2: nil))
//            }
//        }
//    }
//
//    private func isOuterWall(col: Int, row: Int, maze: Maze) -> Bool {
//        return col == 0 || col == maze.height - 1 || row == 0 || row == maze.width - 1
//    }
//
//    private func isCornerWall(col: Int, row: Int, maze: Maze) -> Bool {
//        return (col == 0 && row == 0) ||
//            (col == 0 && row == maze.width - 1) ||
//            (col == maze.height - 1 && row == 0) ||
//            (col == maze.height - 1 && row == maze.width - 1)
//    }
//
//    private func removeWalls(_ maze: Maze) {
//        var currentRoom = maze.matrix[0][0]
//        var roomStack = [currentRoom]
//        var visitedRooms = [currentRoom]
//        while !roomStack.isEmpty {
//            var unvisitedAdjacentRooms = [Room]()
//            for room in adjacentRooms(ofRoom: currentRoom, inMaze: maze) {
//                if !visitedRooms.contains(room) {
//                    unvisitedAdjacentRooms.append(room)
//                }
//            }
//            if !unvisitedAdjacentRooms.isEmpty {
//                let nextRoom = unvisitedAdjacentRooms[Int(arc4random_uniform(UInt32(unvisitedAdjacentRooms.count)))]
//                roomStack.append(nextRoom)
//
//                let wallToRemove = maze.wall(betweenRooms: currentRoom, room2: nextRoom)
//                currentRoom.walls = currentRoom.walls.filter() { $0 != wallToRemove }
//                nextRoom.walls = nextRoom.walls.filter() { $0 != wallToRemove }
//
//                currentRoom = nextRoom
//                visitedRooms.append(currentRoom)
//            } else {
//                if let room = roomStack.popLast() {
//                    currentRoom = room
//                }
//            }
//        }
//    }
//
//    private func adjacentRooms(ofRoom room: Room, inMaze maze: Maze) -> [Room] {
//        var rooms = [Room]()
//        if room.x + 1 < maze.width {
//            rooms.append(maze.matrix[room.x + 1][room.y])
//        }
//        if room.y + 1 < maze.height {
//            rooms.append(maze.matrix[room.x][room.y + 1])
//        }
//        if room.x - 1 >= 0 {
//            rooms.append(maze.matrix[room.x - 1][room.y])
//        }
//        if room.y - 1 >= 0 {
//            rooms.append(maze.matrix[room.x][room.y - 1])
//        }
//        return rooms
//    }
    
//    func printMatrix(_ matrix: [[Room]]) {
//        for row in matrix {
//            for room in row {
//                print()
//                print("Room " + String(room.x) + "," + String(room.y))
//                print(String(room.walls.count) + " walls")
//                for wall in room.walls {
//                    if let room1 = wall.room1, let room2 = wall.room2 {
//                        print("Wall:")
//                        print("Room 1: " + String(room1.x) + "," + String(room1.y))
//                        print("Room 2: " + String(room2.x) + "," + String(room2.y))
//                    }
//                }
//            }
//        }
//    }
}
