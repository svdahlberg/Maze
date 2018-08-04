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
    func player(_ player: Player, didReach goal: Goal)
    func player(_ player: Player, didCollect key: Key)
    func player(_ player: Player, didMoveIn direction: Direction)
}

class Player: GKEntity {
    
    var movementDirection: Direction?
    
    var isControllable: Bool = true
    
    private(set) var numberOfMovesMade: Int = 0
    
    weak var delegate: PlayerDelegate?
    
    private let movementSpeed: CGFloat = 200
    private let moveActionKey = "MovePlayer"
    
    private lazy var spriteNode: SKSpriteNode? = component(ofType: SpriteComponent.self)?.node
    private lazy var mazeNode: MazeNode? = spriteNode?.parent as? MazeNode
    
    override init() {
        super.init()
        
        ColliderType.definedCollisions[.player] = []
        ColliderType.requestedContactNotifications[.player] = [.goal, .key]
    
        let nodeSize = CGSize(width: 10, height: 10)
        let spriteComponent = SpriteComponent(shape: .circle, size: nodeSize, fillColor: .red, strokeColor: .clear)
        addComponent(spriteComponent)
        
        let physicsBody = SKPhysicsBody(rectangleOf: nodeSize)
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .player)
        addComponent(physicsComponent)
        spriteComponent.node.physicsBody = physicsComponent.physicsBody

    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    func move(inDirection direction: Direction) {
        guard isControllable else { return }
        guard let playerNode = spriteNode, let mazeNode = mazeNode else { return }
        var possibleDirectionsToTravelIn = mazeNode.possibleDirectionsToTravelIn()
        if let movementDirection = movementDirection {
            possibleDirectionsToTravelIn = [movementDirection.opposite]
        }
        guard possibleDirectionsToTravelIn.contains(direction) else { return }
        movementDirection = direction
        playerNode.removeAction(forKey: moveActionKey)
        let moveAction = SKAction.move(to: mazeNode.positionForNextRoom(inDirection: direction),
                                       duration: TimeInterval.duration(toMoveFrom: playerNode.position, to: mazeNode.positionForNextRoom(inDirection: direction), with: movementSpeed))
        let completion = SKAction.run {
            mazeNode.updateCurrentRoom(withRoomInDirection: direction)
            self.movementDirection = nil
//            self.addComponent(MovementIndicatorComponent(directions: mazeNode.possibleDirectionsToTravelIn()))
        }
        
        playerNode.run(SKAction.sequence([moveAction, completion]), withKey: moveActionKey)
        numberOfMovesMade += 1
        delegate?.player(self, didMoveIn: direction)
//        removeComponent(ofType: MovementIndicatorComponent.self)
    }
    
}


extension Player: ContactNotifiableType {
    func contactWithEntityDidBegin(_ entity: GKEntity, contact: SKPhysicsContact) {
        if let goal = entity as? Goal {
            delegate?.player(self, didReach: goal)
        }
        
        if let key = entity as? Key {
            key.collected = true
            delegate?.player(self, didCollect: key)
        }
    }
    
    func contactWithEntityDidEnd(_ entity: GKEntity, contact: SKPhysicsContact) {}
}

