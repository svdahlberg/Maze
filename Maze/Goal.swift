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
    
    var reached: Bool = false {
        didSet {
            guard let node = component(ofType: SpriteComponent.self)?.node else { return }
            node.isHidden = reached
        }
    }
    
    init(room: Room, shape: Shape) {
        self.room = room
        super.init()
        
        ColliderType.definedCollisions[.goal] = []
        ColliderType.requestedContactNotifications[.goal] = [.player]
        
        let nodeSize = CGSize(width: 10, height: 10)
        let spriteComponent = SpriteComponent(shape: shape, size: nodeSize, fillColor: .clear, strokeColor: .yellow)
        addComponent(spriteComponent)
        
        let physicsBody = SKPhysicsBody(rectangleOf: nodeSize)
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


