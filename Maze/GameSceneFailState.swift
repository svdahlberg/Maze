//
//  GameSceneFailState.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneFailState: GameSceneOverlayState {
    
    private var tryAgainButton: ButtonNode?
    
    override var overlaySceneFileName: String {
        return "FailScene"
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        tryAgainButton = overlay.contentNode.childNode(withName: "tryAgainButton") as? ButtonNode
        tryAgainButton?.action = { [weak self] () in self?.presentSameLevelGameScene() }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    private func presentSameLevelGameScene() {
        let scene = GameScene(size: gameScene.size, level: Level(number: gameScene.game.level.number))
        
        guard let view = gameScene.view else { return }
        view.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        let transition = SKTransition.reveal(with: .down, duration: 1)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false
        view.presentScene(scene, transition: transition)
    }
}



