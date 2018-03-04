//
//  Player.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol PlayerDelegate: class {
    func playerDidReachGoal(_ goal: Goal)
    func playerDidCollectKey(_ key: Key)
}

class Player: GKEntity {
    
    var movementDirection: Direction?
    private let movementSpeed: CGFloat = 200
    private let moveActionKey = "MovePlayer"
    
    weak var delegate: PlayerDelegate?
    
    override init() {
        super.init()
        
        ColliderType.definedCollisions[.player] = []
        ColliderType.requestedContactNotifications[.player] = [.goal, .key]
    
        let node = SKSpriteNode(color: .red, size: CGSize(width: 10, height: 10))
        let spriteComponent = SpriteComponent(node: node)
        addComponent(spriteComponent)
        
        let physicsBody = SKPhysicsBody(rectangleOf: node.size)
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .player)
        addComponent(physicsComponent)
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        
        let lightComponent = LightComponent(lightCategory: .playerLight)
        addComponent(lightComponent)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(inDirection direction: Direction, inMazeNode mazeNode: MazeNode) {
        guard let playerNode = component(ofType: SpriteComponent.self)?.node else { return }
        var possibleDirectionsToTravelIn = mazeNode.possibleDirectionsToTravelIn()
        if let movementDirection = movementDirection {
            possibleDirectionsToTravelIn = [movementDirection.opposite]
        }
        guard possibleDirectionsToTravelIn.contains(direction) else { return }
        movementDirection = direction
        playerNode.removeAction(forKey: moveActionKey)
        let moveAction = SKAction.move(to: mazeNode.positionForNextRoom(inDirection: direction),
                                       duration: duration(toMoveFromPointA: playerNode.position, toPointB: mazeNode.positionForNextRoom(inDirection: direction), withSpeed: movementSpeed))
        let completion = SKAction.run {
            mazeNode.updateCurrentRoom(withRoomInDirection: direction)
            self.movementDirection = nil
        }
        playerNode.run(SKAction.sequence([moveAction, completion]), withKey: moveActionKey)
    }
    
    private func duration(toMoveFromPointA pointA: CGPoint, toPointB pointB: CGPoint, withSpeed speed: CGFloat) -> TimeInterval {
        let xDist = (pointB.x - pointA.x)
        let yDist = (pointB.y - pointA.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist))
        return TimeInterval(distance/speed)
    }
}


extension Player: ContactNotifiableType {
    func contactWithEntityDidBegin(_ entity: GKEntity, contact: SKPhysicsContact) {
        if let goal = entity as? Goal {
            delegate?.playerDidReachGoal(goal)
        }
        
        if let key = entity as? Key {
            key.collected = true
            delegate?.playerDidCollectKey(key)
        }
    }
    
    func contactWithEntityDidEnd(_ entity: GKEntity, contact: SKPhysicsContact) {}
}

