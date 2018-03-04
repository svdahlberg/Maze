//
//  RoomNode.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-06.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import SpriteKit

class RoomNode: SKSpriteNode {
    
    var room: Room
    let wallWidth: CGFloat = 3
    let wallColor: SKColor = .black
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, room: Room, maze: Maze) {
        self.room = room
        super.init(texture: texture, color: color, size: size)
        createWalls()
        createOuterWalls(inMaze: maze)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createWalls() {
        room.walls.forEach { createWall($0.wallPlacement) }
    }
    
    private func createOuterWalls(inMaze maze: Maze) {
        if room.isCornerRoom {
            createWalls(room.wallPlacementsForCornerRoom(in: maze))
            return
        }
        if let placement = room.wallPlacementForOuterWall(in: maze) {
            createWall(placement)
        }
    }
    
    private func createWalls(_ placements: [WallPlacement]) {
        for placement in placements {
            createWall(placement)
        }
    }
    
    private func createWall(_ placement: WallPlacement) {
        let wall = SKSpriteNode(color: wallColor, size: wallSizeForPlacement(placement))
        wall.position = wallPositionForPlacement(placement)
        let wallPhysicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wallPhysicsBody.isDynamic = false
        wall.physicsBody = wallPhysicsBody
        wall.lightingBitMask = LightCategory.allValuesBitMask()
        wall.shadowCastBitMask = LightCategory.allValuesBitMask()
        wall.shadowedBitMask = LightCategory.allValuesBitMask()
        addChild(wall)
    }
    
    private func wallSizeForPlacement(_ placement: WallPlacement) -> CGSize {
        switch placement {
        case .right, .left: return CGSize(width: wallWidth, height: frame.size.height + wallWidth * 2)
        case .top, .bottom: return CGSize(width: frame.size.width + wallWidth * 2, height: wallWidth)
        case .outer: return .zero
        }
    }
    
    private func wallPositionForPlacement(_ placement: WallPlacement) -> CGPoint {
        switch placement {
        case .right:
            return CGPoint(x: frame.size.width/2 - wallWidth/2, y: 0)
        case .left:
            return CGPoint(x: -frame.size.width/2 + wallWidth/2, y: 0)
        case .top:
            return CGPoint(x: 0, y: frame.size.height/2 - wallWidth/2)
        case .bottom:
            return CGPoint(x: 0, y: -frame.size.height/2 + wallWidth/2)
        case .outer:
            return .zero
        }
    }
}
