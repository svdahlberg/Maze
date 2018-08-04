//
//  SpriteComponent.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Shape {
    
    case circle, square
    
    func node(of size: CGSize) -> SKShapeNode? {
        switch self {
        case .circle:
            return SKShapeNode(circleOfRadius: size.width/2)
        case .square:
            return SKShapeNode(rect: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
        }
    }
    
}

class SpriteComponent: GKComponent {
    
    let shape: Shape
    
    let node: SKSpriteNode
    
    init(shape: Shape, size: CGSize, fillColor: SKColor, strokeColor: SKColor) {
        self.shape = shape
        self.node = SKSpriteNode(color: .clear, size: size)
        super.init()
        node.lightingBitMask = LightCategory.allValuesBitMask()
        
        guard let shapeNode = shape.node(of: size) else { return }
        shapeNode.fillColor = fillColor
        shapeNode.strokeColor = strokeColor
        shapeNode.isAntialiased = false
        node.addChild(shapeNode)
        
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

