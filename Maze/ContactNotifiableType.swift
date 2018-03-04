//
//  ContactNotifiableType.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import GameplayKit

protocol ContactNotifiableType {
    func contactWithEntityDidBegin(_ entity: GKEntity, contact: SKPhysicsContact)
    func contactWithEntityDidEnd(_ entity: GKEntity, contact: SKPhysicsContact)
}

