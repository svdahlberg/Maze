//
//  MovementIndicatorNode.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-21.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import SpriteKit

class MovementIndicatorNode: SKSpriteNode {
    
    private let direction: Direction
    
    init(direction: Direction, color: SKColor, width: CGFloat, height: CGFloat) {
        self.direction = direction
        let size = (direction == .left || direction == .right) ? CGSize(width: height, height: width) : CGSize(width: width, height: height)
        super.init(texture: nil, color: .blue, size: size)
        addChild(arrowShape(color: color))
        run(animationAction)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    private lazy var animationAction: SKAction = {
        let scaleUp = SKAction.scale(by: 1.1, duration: 0.5)
        let scaleDown = scaleUp.reversed()
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        return SKAction.repeatForever(sequence)
    }()
    
    private func arrowShape(color: SKColor) -> SKShapeNode {
        let shape = SKShapeNode(path: arrowPath)
        shape.lineWidth = 0.5
        shape.strokeColor = color
        return shape
    }
    
    private lazy var arrowPath: CGPath = {
        let path = UIBezierPath()
        path.move(to: startingPoint())
        path.addLine(to: middlePoint())
        path.addLine(to: endPoint())
        path.lineCapStyle = .round
        return path.cgPath
    }()
    
    private func startingPoint() -> CGPoint {
        switch direction {
        case .left: return CGPoint(x: frame.width, y: 0)
        case .right: return .zero
        case .down: return .zero
        case .up: return CGPoint(x: 0, y: frame.height)
        }
    }

    private func middlePoint() -> CGPoint {
        switch direction {
        case .left: return CGPoint(x: 0, y: frame.height/2)
        case .right: return CGPoint(x: frame.width, y: frame.height/2)
        case .down: return CGPoint(x: frame.width/2, y: frame.height)
        case .up: return CGPoint(x: frame.width/2, y: 0)
        }
    }
    
    private func endPoint() -> CGPoint {
        switch direction {
        case .left: return CGPoint(x: frame.width, y: frame.height)
        case .right: return CGPoint(x: 0, y: frame.height)
        case .down: return CGPoint(x: frame.width, y: 0)
        case .up: return CGPoint(x: frame.width, y: frame.height)
        }
    }
    
}

private extension Direction {
    
    func degrees() -> CGFloat {
        switch self {
        case .up: return .pi/2
        case .down: return 3 * .pi/2
        case .left: return .pi
        case .right: return 0
        }
    }
    
}
