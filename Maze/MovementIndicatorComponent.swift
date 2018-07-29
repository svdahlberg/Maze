//
//  MovementIndicatorComponent.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-21.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementIndicatorComponent: GKComponent {
    
    private lazy var spriteNode: SKSpriteNode? = entity?.component(ofType: SpriteComponent.self)?.node
    
    private let directions: [Direction]
    private var movementIndicatorNodes = [MovementIndicatorNode]()
    
    init(directions: [Direction]) {
        self.directions = directions
        super.init()
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        addMovementIndicators(for: directions)
    }
    
    override func willRemoveFromEntity() {
        super.willRemoveFromEntity()
        movementIndicatorNodes.forEach { $0.removeFromParent() }
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
    private func addMovementIndicators(for directions: [Direction]) {
        guard let spriteNode = spriteNode else { return }
        movementIndicatorNodes = self.movementIndicatorNodes(from: directions)
        movementIndicatorNodes.forEach { spriteNode.addChild($0) }
    }
    
    private func movementIndicatorNodes(from directions: [Direction]) -> [MovementIndicatorNode] {
        return directions.map {
            let movementIndicatorNode = MovementIndicatorNode(direction: $0, color: Appearance.accentColor, width: 5, height: 2)
            let movementIndicatorNodeSize = movementIndicatorNode.size
            movementIndicatorNode.position = movementIndicatorPosition(for: $0, movementIndicatorSize: movementIndicatorNodeSize)
            return movementIndicatorNode
        }
    }
    
    private func movementIndicatorPosition(for direction: Direction, movementIndicatorSize: CGSize) -> CGPoint {
        let offset: CGFloat = 10
        switch direction {
        case .right: return CGPoint(x: offset, y: 0)
        case .left: return CGPoint(x: -offset, y: 0)
        case .up: return CGPoint(x: 0, y: offset)
        case .down: return CGPoint(x: 0, y: -offset)
        }
    }
    
}
