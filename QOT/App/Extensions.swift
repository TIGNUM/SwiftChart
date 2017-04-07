//
//  Extensions.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIFont

extension UIFont {
    
    internal class func simpleFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.simple.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    internal class func bentonBookFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonBook.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    internal class func bentonRegularFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonBook.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
}

// MARK: - NSAttributedString

extension NSAttributedString {

    internal class func create(for string: String, withColor color: UIColor, andFont font: UIFont) -> NSAttributedString {
        let attributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
        return NSAttributedString(string: string, attributes: attributes)
    }
}

// MARK: - UIBezierPath

extension UIBezierPath {

    class func circlePath(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let startAngle = CGFloat(0)
        let endAngle = CGFloat(Double.pi * 2)

        return UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
    }
}

// MARK: - CAShapeLayer

extension CAShapeLayer {

    class func pathWithColor(path: CGPath, fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = 1.0
        return shapeLayer
    }

    class func line(from fromPoint: CGPoint, to toPoint: CGPoint, strokeColor: UIColor) -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: fromPoint)
        linePath.addLine(to: toPoint)
        line.path = linePath.cgPath
        line.strokeColor = strokeColor.cgColor
        line.lineWidth = 0.6
        line.lineJoin = kCALineJoinRound
        return line
    }
}

// MARK: - Int

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

// MARK: - FloatingPoint

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

// MARK: - Collection

extension MutableCollection where Index == Int {
    mutating func shuffle() {
        guard count > 2 else {
            return
        }

        for index in startIndex ..< endIndex - 1 {
            let element = Int(arc4random_uniform(UInt32(endIndex - index))) + index
            if index != element {
                swap(&self[index], &self[element])
            }
        }
    }
}

extension Collection {
    func shuffled() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}
