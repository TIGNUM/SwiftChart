//
//  CGPoint+Convenience.swift
//  QOT
//
//  Created by tignum on 3/28/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension CGPoint {
    func distanceTo(_ point: CGPoint) -> CGFloat {
        let deltaX = abs(point.x - x)
        let deltaY = abs(point.y - y)
        return sqrt(pow(deltaX, 2) + pow(deltaY, 2))
    }
    
    func insideCircle(frame: CGRect) -> Bool {
        let radius = frame.width / 2
        let center = CGPoint(x: frame.midX, y: frame.midY)
        return center.distanceTo(self) <= radius
    }

    /// Will return a new point depending on a given point.
    ///
    /// - Parameters:
    ///     - dsitance:         The distance from the relative center.
    ///     - angle:            The angle in radians.
    func shifted(_ distance: CGFloat, with angle: CGFloat) -> CGPoint {
        let converted = angle.degreesToRadians
        let xPos = self.x + distance * cos(converted)
        let yPos = self.y + distance * sin(converted)
        return CGPoint(x: xPos, y: yPos)
    }

    var rounded: CGPoint {
        return CGPoint(x: x.rounded(), y: y.rounded())
    }

    func adding(x deltaX: CGFloat = 0, y deltaY: CGFloat = 0) -> CGPoint {
        return CGPoint(x: x + deltaX, y: y + deltaY)
    }
}
