//
//  LightComponent.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-08-20.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//


import Foundation
import GameplayKit


enum LightCategory: UInt32 {
    case playerLight = 1
    case goalLight = 2
    
    static let allValues = [playerLight, goalLight]
    
//    static func allValuesBitMask() -> UInt32 { return playerLight.rawValue | goalLight.rawValue }
    
    static func allValuesBitMask() -> UInt32 {
        return LightCategory.allValues.reduce(0) { initial, lightCategory in lightCategory.rawValue | initial }
    }
}

struct LightType {
    var falloff: CGFloat
    var ambientColor: SKColor
    var lightColor: SKColor
    var lightCategory: LightCategory
    
    init(lightCategory: LightCategory) {
        self.lightCategory = lightCategory
        switch lightCategory {
        case .playerLight:
            falloff = 2
            ambientColor = .black
            lightColor = .white
        case .goalLight:
            falloff = 4
            ambientColor = .black
            lightColor = .yellow
        }
    }
    
    var lightingMask: UInt32 {
        var categories = Set(LightCategory.allValues)
        categories.subtract(Set([lightCategory]))
        return categories.reduce(0) { initial, lightCategory in lightCategory.rawValue | initial }
    }
}


class LightComponent: GKComponent {
    
    var lightType: LightType
    var lightNode: SKLightNode
    
    init(lightCategory: LightCategory) {
        lightType = LightType(lightCategory: lightCategory)
        lightNode = SKLightNode()
        super.init()
    }
    
    override func didAddToEntity() {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            fatalError("LightComponent requires the entity to have a SpriteComponent")
        }
        
        lightNode.falloff = lightType.falloff
        lightNode.ambientColor = lightType.ambientColor
        lightNode.lightColor = lightType.lightColor
        lightNode.categoryBitMask = lightType.lightCategory.rawValue
        
        spriteComponent.node.lightingBitMask = LightCategory.allValuesBitMask()
        spriteComponent.node.shadowedBitMask = LightCategory.allValuesBitMask()
        spriteComponent.node.shadowCastBitMask = LightCategory.allValuesBitMask()
        
        spriteComponent.node.addChild(lightNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

