//
//  SwipeControls.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-18.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import SpriteKit

protocol SwipeControlsDelegate: class {
    func swipeControls(_ swipeControls: SwipeControls, didSwipeIn direction: Direction)
}

class SwipeControls {
    
    weak var delegate: SwipeControlsDelegate?
    
    func setup(on view: SKView) {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) -> Void {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right: delegate?.swipeControls(self, didSwipeIn: .right)
        case UISwipeGestureRecognizerDirection.left: delegate?.swipeControls(self, didSwipeIn: .left)
        case UISwipeGestureRecognizerDirection.up: delegate?.swipeControls(self, didSwipeIn: .up)
        case UISwipeGestureRecognizerDirection.down: delegate?.swipeControls(self, didSwipeIn: .down)
        default: break
        }
    }
    
}
