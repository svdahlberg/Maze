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
    
    private lazy var continueButton: ButtonNode? = {
        let buttonNode = overlay.contentNode.childNode(withName: "continueButton") as? ButtonNode
        buttonNode?.color = Appearance.accentColor
        return buttonNode
    }()
    
    override var overlaySceneFileName: String {
        return "SuccessScene"
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        continueButton?.action = { [weak self] () in self?.presentNextLevelGameScene() }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    private func presentNextLevelGameScene() {
        guard let view = gameScene.view else { return }
        let nextLevel = gameScene.game.level.number + 1
        let transition = SKTransition.reveal(with: .down, duration: 1)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false
        SceneManager(presentingView: view).presentScene(with: .game(Level(number: nextLevel)), transition: transition)
    }
}


