//
//  GameSceneSuccessState.swift
//  Maze
//
//  Created by Svante Dahlberg on 2018-03-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneSuccessState: GameSceneOverlayState {
    
    private var continueButton: ButtonNode?
    
    override var overlaySceneFileName: String {
        return "SuccessScene"
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        continueButton = overlay.contentNode.childNode(withName: "continueButton") as? ButtonNode
        continueButton?.action = { [weak self] () in self?.presentNextLevelGameScene() }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    private func presentNextLevelGameScene() {
        guard let scene = GameScene(fileNamed: "GameScene"),
            let view = gameScene.view else { return }
        view.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        let transition = SKTransition.reveal(with: .down, duration: 1)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false
        view.presentScene(scene, transition: transition)
    }
}


