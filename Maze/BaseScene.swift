//
//  BaseScene.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-09-11.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//


import SpriteKit

class BaseScene: SKScene {
    
    var overlay: OverlayNode? {
        didSet {
            if let overlay = overlay, let camera = camera {
                overlay.backgroundNode.removeFromParent()
                camera.addChild(overlay.backgroundNode)
                overlay.backgroundNode.alpha = 0.0
                overlay.backgroundNode.run(SKAction.fadeIn(withDuration: 0.25))
                overlay.updateScale()
            }
            
            oldValue?.backgroundNode.run(SKAction.fadeOut(withDuration: 0.25)) {
                oldValue?.backgroundNode.removeFromParent()
            }
            
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        overlay?.updateScale()
    }
    
}

