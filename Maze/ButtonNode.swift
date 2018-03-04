//
//  ButtonNode.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-09-11.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    var action: (() -> ())?
    
    var isHighlighted = false {
        didSet {
            guard oldValue != isHighlighted else { return }
            let newScale: CGFloat = isHighlighted ? 0.9 : 1.1
            let scaleAction = SKAction.scale(by: newScale, duration: 0.1)
            let newColorBlendFactor: CGFloat = isHighlighted ? 1.0 : 0.0
            let colorBlendAction = SKAction.colorize(withColorBlendFactor: newColorBlendFactor, duration: 0.1)
            run(SKAction.group([scaleAction, colorBlendAction]))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func buttonTriggered() {
        guard isUserInteractionEnabled else { return }
        action?()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        if contains(touches: touches) {
            buttonTriggered()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
    }
    
    private func contains(touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.") }
        
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
}



