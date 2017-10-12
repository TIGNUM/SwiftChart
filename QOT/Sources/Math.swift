//
//  Math.swift
//  QOT
//
//  Created by Moucheg Mouradian on 12/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

struct Math {

    static func pointOnCircle(center: CGPoint, withRadius radius: CGFloat, andAngle angle: CGFloat) -> CGPoint {
        return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }

    static func radians(_ angle: CGFloat) -> CGFloat {
        return CGFloat(Float.pi) * (angle / 180)
    }
}

var randomNumber: CGFloat {
    return (CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
}
