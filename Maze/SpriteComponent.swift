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
    
    static func random() -> Shape {
        let allCases: [Shape] = [.circle, .square]
        let randomIndex = Int(arc4random_uniform(UInt32(allCases.count)))
        return allCases[randomIndex]
    }
}

class SpriteComponent: GKComponent {
    
    var shape: Shape {
        didSet {
            setupShapeNode()
        }
    }
    
    let node: SKSpriteNode
    
    let fillColor: SKColor
    let strokeColor: SKColor
    var shapeNode: SKShapeNode?
    
    init(shape: Shape, size: CGSize, fillColor: SKColor, strokeColor: SKColor) {
        self.shape = shape
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.node = SKSpriteNode(color: .clear, size: size)
        super.init()
        node.lightingBitMask = LightCategory.allValuesBitMask()
        
        setupShapeNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupShapeNode() {
        guard let shapeNode = shape.node(of: node.size) else { return }
        self.shapeNode?.removeFromParent()
        shapeNode.fillColor = fillColor
        shapeNode.strokeColor = strokeColor
        shapeNode.isAntialiased = false
        node.addChild(shapeNode)
        self.shapeNode = shapeNode
    }
    
    override func didAddToEntity() {
        node.entity = entity
    }
    
    override func willRemoveFromEntity() {
        node.entity = nil
    }
    
}

