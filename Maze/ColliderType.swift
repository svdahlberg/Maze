//
//  ColliderType.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

struct ColliderType: OptionSet {
    
    static var requestedContactNotifications = [ColliderType: [ColliderType]]()
    static var definedCollisions = [ColliderType: [ColliderType]]()
    
    let rawValue: UInt32
    
    static var player: ColliderType { return self.init(rawValue: 1 << 0) }
    static var goal: ColliderType { return self.init(rawValue: 1 << 1) }
    
    static let allValues: [ColliderType] = [.player, .goal]
    
    var categoryMask: UInt32 {
        return rawValue
    }
    
    var collisionMask: UInt32 {
        let mask = ColliderType.definedCollisions[self]?.reduce(ColliderType()) { initial, colliderType in
            return initial.union(colliderType)
        }
        return mask?.rawValue ?? 0
    }
    
    var contactMask: UInt32 {
        let mask = ColliderType.requestedContactNotifications[self]?.reduce(ColliderType()) { initial, colliderType in
            return initial.union(colliderType)
        }
        return mask?.rawValue ?? 0
    }
    
    
    func notifyOnContactWith(_ colliderType: ColliderType) -> Bool {
        if let requestedContacts = ColliderType.requestedContactNotifications[self] {
            return requestedContacts.contains(colliderType)
        }
        return false
    }
}

extension ColliderType: Hashable {
    var hashValue: Int {
        return Int(rawValue)
    }
}

