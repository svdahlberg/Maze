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
    
    private lazy var scaleDownAction: SKAction = {
        let action = SKAction.scale(by: 0.9, duration: 0.1)
        action.timingMode = .easeOut
        return action
    }()
    
    private lazy var scaleUpAction: SKAction = {
        let action = SKAction.scale(by: 1.1, duration: 0.1)
        action.timingMode = .easeIn
        return action
    }()
    
    private let fadeOutAction = SKAction.fadeAlpha(to: 0.7, duration: 0.1)
    
    private let fadeInAction = SKAction.fadeAlpha(to: 1, duration: 0.1)
    
    private(set) var isHighlighted = false {
        didSet {
            guard oldValue != isHighlighted else { return }
            let scaleAction = isHighlighted ? scaleDownAction : scaleUpAction
            let fadeAction  = isHighlighted ? fadeOutAction : fadeInAction
            run(SKAction.group([scaleAction, fadeAction]))
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        if contains(touches: touches) { action?() }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
    }
    
    private func contains(touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { return false }
        
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
  
}
