//
//  SpriteComponent.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    var node = SKSpriteNode()
    
    init(node: SKSpriteNode) {
        super.init()
        node.lightingBitMask = LightCategory.allValuesBitMask()
        self.node = node
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        node.entity = entity
    }
    
    override func willRemoveFromEntity() {
        node.entity = nil
    }
    
}

