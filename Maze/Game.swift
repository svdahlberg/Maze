//
//  Game.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-03.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Game {
    
    private var entities = Set<GKEntity>()
    
    lazy var mazeNode: MazeNode = {
        let mazeNode = MazeNode(color: .darkGray, roomSize: CGSize(width: 30, height: 30), dimensions: (cols: level.mazeDimensions.columns, rows: level.mazeDimensions.rows))
        return mazeNode
    }()
    
    let player = Player()
    
    lazy var goal: Goal? = {
        guard let goalRoom = mazeNode.deadEnds()?.last else { return nil }
        return Goal(room: goalRoom)
    }()
    
    var keys: [Key]?
    
    let level: Level
    
    var numberOfKeys: Int {
        guard let keys = keys else { return 0 }
        return keys.count
    }
    
    var numberOfCollectedKeys: Int {
        guard let keys = keys else { return 0 }
        return keys.filter { $0.collected }.count
    }
    
    var allKeysCollected: Bool {
        guard let keys = keys else { return true }
        return !keys.contains { key in
            return !key.collected
        }
    }
    
    init(level: Level) {
        self.level = level
        placePlayerInMaze()
        placeGoalInMaze()
//        placeKeysInMaze()
    }
    
    func update(with deltaTime: TimeInterval) {
        entities.forEach { $0.update(deltaTime: deltaTime) }
    }
    
    private func placePlayerInMaze() {
        guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return }
        playerNode.position = mazeNode.positionForCurrentRoom()
        mazeNode.addChild(playerNode)
        entities.insert(player)
    }
    
    private func placeGoalInMaze() {
        guard let goal = goal,
            let goalNode = goal.component(ofType: SpriteComponent.self)?.node
            else { return }
        goalNode.position = mazeNode.position(forRoom: goal.room)
        mazeNode.addChild(goalNode)
        entities.insert(goal)
    }
    
    private func placeKeysInMaze() {
        guard let deadEnds = mazeNode.deadEnds() else { return }
        let possibleKeyRooms = Array(deadEnds.dropLast().dropFirst())
        let keyRooms = possibleKeyRooms[randomPick: 3]
        keys = keyRooms.map { (room: Room) -> Key in
            let key = Key()
            if let keyNode = key.component(ofType: SpriteComponent.self)?.node {
                keyNode.position = mazeNode.position(forRoom: room)
                mazeNode.addChild(keyNode)
            }
            entities.insert(key)
            return key
        }
    }

}
