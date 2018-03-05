//
//  Goal.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class Goal: GKEntity {
    
    let room: Room
    
    init(room: Room) {
        self.room = room
        super.init()
        
        ColliderType.definedCollisions[.goal] = []
        ColliderType.requestedContactNotifications[.goal] = [.player]
        
        let node = SKSpriteNode(color: .yellow, size: CGSize(width: 20, height: 20))
        let spriteComponent = SpriteComponent(node: node)
        addComponent(spriteComponent)
        
        let physicsBody = SKPhysicsBody(rectangleOf: node.size)
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .goal)
        addComponent(physicsComponent)
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension Goal: ContactNotifiableType {
    func contactWithEntityDidBegin(_ entity: GKEntity, contact: SKPhysicsContact) {
    
    }
    func contactWithEntityDidEnd(_ entity: GKEntity, contact: SKPhysicsContact) {
    
    }
}


