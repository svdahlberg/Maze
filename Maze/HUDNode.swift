//
//  HUDNode.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
import SpriteKit

class HUDNode: SKNode {
    
    var movesLeft: Int? {
        didSet {
            guard let movesLeft = movesLeft else {
                movesLeftLabel?.text = nil
                return
            }
            
            movesLeftLabel?.text = "\(movesLeft)"
        }
    }
    
    private lazy var contentNode: SKSpriteNode = {
        let contentNode = SKSpriteNode()
        contentNode.position = .zero
        contentNode.color = .clear
        return contentNode
    }()
    
    private lazy var hudScene = SKScene(fileNamed: "HUD")
    
    private lazy var nativeContentSize = hudScene?.size
    
    private lazy var movesLeftLabel = contentNode.childNode(withName: "movesLeftLabel") as? SKLabelNode
    
    init(movesLeft: Int?) {
        defer { self.movesLeft = movesLeft }
        super.init()
        loadFromScene()
        addChild(contentNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScale() {
        guard let viewSize = scene?.view?.frame.size,
            let nativeContentSize = nativeContentSize
            else {
                return
        }

        let scale = viewSize.height / nativeContentSize.height
        contentNode.setScale(scale)
    }
    
    private func loadFromScene() {
        hudScene?.children.forEach {
            guard let node = $0.copy() as? SKNode else { return }
            contentNode.addChild(node)
        }
    }
    
}
