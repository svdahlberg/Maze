//
//  Key.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-09-10.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Key: GKEntity {
    
    let room: Room
    
    var collected: Bool = false {
        didSet {
            guard let node = component(ofType: SpriteComponent.self)?.node else { return }
            node.isHidden = collected
        }
    }
    
    init(room: Room) {
        
        self.room = room
        
        super.init()
        
        ColliderType.definedCollisions[.key] = []
        ColliderType.requestedContactNotifications[.key] = [.player]
        
        let node = SKSpriteNode(color: .orange, size: CGSize(width: 5, height: 5))
        let spriteComponent = SpriteComponent(shape: .square, size: CGSize(width: 5, height: 5), fillColor: .yellow, strokeColor: .yellow)
        addComponent(spriteComponent)
        
        let physicsBody = SKPhysicsBody(rectangleOf: node.size)
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .key)
        addComponent(physicsComponent)
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension Key: ContactNotifiableType {
    func contactWithEntityDidBegin(_ entity: GKEntity, contact: SKPhysicsContact) {
        
    }
    func contactWithEntityDidEnd(_ entity: GKEntity, contact: SKPhysicsContact) {
        
    }
}
