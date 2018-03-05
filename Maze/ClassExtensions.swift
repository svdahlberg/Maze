//
//  ClassExtensions.swift
//  Maze
//
//  Created by Svante Dahlberg on 2017-09-10.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import SpriteKit

extension CGPoint {
    func distance(fromPoint point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}

extension Array {
    subscript (randomPick n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: Swift.max((count - n - 1), 0), by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
}

extension TimeInterval {
    static func duration(toMoveFrom pointA: CGPoint, to pointB: CGPoint, with speed: CGFloat) -> TimeInterval {
        let xDistance = (pointB.x - pointA.x)
        let yDistance = (pointB.y - pointA.y)
        let distance = sqrt((xDistance * xDistance) + (yDistance * yDistance))
        return TimeInterval(distance/speed)
    }
}
