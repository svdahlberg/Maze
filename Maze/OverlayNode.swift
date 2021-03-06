//
//  SceneOverlay.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-09-11.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import SpriteKit

class OverlayNode: SKNode {
    
    let backgroundNode: SKSpriteNode
    let contentNode: SKSpriteNode
    let nativeContentSize: CGSize
    
    init(overlaySceneFileName fileName: String, zPosition: CGFloat) {
        
        let overlayScene = SKScene(fileNamed: fileName)!
        let contentTemplateNode = overlayScene.childNode(withName: "Overlay") as! SKSpriteNode
        
        backgroundNode = SKSpriteNode(color: contentTemplateNode.color, size: contentTemplateNode.size)
        backgroundNode.zPosition = zPosition
        contentNode = contentTemplateNode.copy() as! SKSpriteNode
        contentNode.position = .zero
        backgroundNode.addChild(contentNode)
        contentNode.color = .clear
        nativeContentSize = contentNode.size
        contentNode.isPaused = false
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScale() {
        guard let viewSize = scene?.view?.frame.size else {
            return
        }

        backgroundNode.size = viewSize
        let scale = viewSize.height / nativeContentSize.height
        contentNode.setScale(scale)
    }
}

