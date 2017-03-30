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
}
