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
    
    private lazy var tryAgainButton: ButtonNode? = {
        let buttonNode = overlay.contentNode.childNode(withName: "tryAgainButton") as? ButtonNode
        buttonNode?.color = Appearance.accentColor
        return buttonNode
    }()
    
    override var overlaySceneFileName: String {
        return "FailScene"
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        tryAgainButton?.onPress = { [weak self] () in self?.presentSameLevelGameScene() }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    private func presentSameLevelGameScene() {
        guard let view = gameScene.view else { return }
        let transition = SKTransition.reveal(with: .down, duration: 1)
        transition.pausesOutgoingScene = false
        transition.pausesIncomingScene = false
        SceneManager(presentingView: view).presentScene(with: .game(Level(number: gameScene.game.level.number)), transition: transition)
    }
}



