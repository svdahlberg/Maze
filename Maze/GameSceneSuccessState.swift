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
    
    override var overlaySceneFileName: String {
        return "SuccessScene"
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}
