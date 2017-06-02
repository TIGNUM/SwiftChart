//
//  UIBezierPath+Hexagon.swift
//  QOT
//
//  Created by karmic on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {

    class var partnersHexagon: UIBezierPath {
        let clippingBorderPath = UIBezierPath()
        clippingBorderPath.move(to: CGPoint(x: 93, y: 0))
        clippingBorderPath.addLine(to: CGPoint(x: 186, y: 52))
        clippingBorderPath.addLine(to: CGPoint(x: 186, y: 157))
        clippingBorderPath.addLine(to: CGPoint(x: 93, y: 210))
        clippingBorderPath.addLine(to: CGPoint(x: 0, y: 157))
        clippingBorderPath.addLine(to: CGPoint(x: 0, y: 52))
        clippingBorderPath.move(to: CGPoint(x: 93, y: 0))
        clippingBorderPath.close()

        return clippingBorderPath
    }
}
