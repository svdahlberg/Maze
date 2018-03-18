//
//  WallNode.swift
//  Maze
//
//  Created by Svante Dahlberg on 14/08/16.
//  Copyright © 2016 Svante Dahlberg. All rights reserved.
//

import UIKit
import SpriteKit

class MazeNode: SKSpriteNode {
    let maze: Maze
    private let roomSize: CGSize
    var currentRoom: Room {
        didSet {
            maze.currentRoom = currentRoom
        }
    }
    
    var roomNodes = [RoomNode]()
    
    init(color: UIColor, size: CGSize, dimensions: MazeDimensions) {
        maze = Maze(dimensions: dimensions)
        roomSize = CGSize(width: size.width/CGFloat(maze.dimensions.rows), height: size.height/CGFloat(maze.dimensions.columns))
        currentRoom = maze.currentRoom
        super.init(texture: nil, color: color, size: size)
        anchorPoint = CGPoint(x: 0, y: 1)
        addRooms()
    }
    
    init(color: UIColor, roomSize: CGSize, dimensions: MazeDimensions) {
        maze = Maze(dimensions: dimensions)
        self.roomSize = roomSize
        currentRoom = maze.currentRoom
        let mazeSize = CGSize(width: CGFloat(maze.rows) * roomSize.width, height: CGFloat(maze.columns) * roomSize.height)
        super.init(texture: nil, color: color, size: mazeSize)
        anchorPoint = CGPoint(x: 0, y: 1)
        addRooms()
        
        lightingBitMask = LightCategory.allValuesBitMask()
        shadowCastBitMask = LightCategory.allValuesBitMask()
        shadowedBitMask = LightCategory.allValuesBitMask()
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    func roomNode(with room: Room) -> RoomNode? {
        return roomNodes.first { $0.room == room }
    }
    
    private func addRooms() {
        for i in 0...maze.rows - 1 {
            for j in 0...maze.columns - 1 {
                let room = maze.matrix[i][j]
                let roomNode = RoomNode(color: .clear, size: roomSize, room: room, maze: maze)
                roomNode.position = position(forRoom: room)
                addChild(roomNode)
                roomNodes.append(roomNode)
            }
        }
    }
    
    func possibleDirectionsToTravelIn() -> [Direction] {
        return maze.possibleDirectionsToTravelIn(from: currentRoom)
    }
    
    func updateCurrentRoom(withRoomInDirection direction: Direction) {
        currentRoom = maze.nextStop(in: direction, from: currentRoom)
    }
    
    func positionForCurrentRoom() -> CGPoint {
        return position(forRoom: currentRoom)
    }
    
    func positionForNextRoom(inDirection direction: Direction) -> CGPoint {
        return position(forRoom: maze.nextStop(in: direction, from: currentRoom))
    }
    
    func position(forRoom room: Room) -> CGPoint {
        return CGPoint(x: roomSize.width/2 * CGFloat(room.x * 2 + 1), y: -roomSize.height/2 * CGFloat(room.y * 2 + 1))
    }
    
    func deadEnds() -> [Room]? {
        return maze.deadEnds()
    }

}
