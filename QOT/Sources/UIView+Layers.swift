//
//  UIView+Layers.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UIView {
    func drawSolidCircle(arcCenter: CGPoint, radius: CGFloat, lineWidth: CGFloat, value: CGFloat = 1.0, startAngle: CGFloat = -90.0, strokeColour: UIColor) {
        let angleStart = Math.radians(startAngle)
        let angleEnd = Math.radians(360 * value + startAngle)

        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius - lineWidth / 2, startAngle: angleStart, endAngle: angleEnd, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColour.cgColor
        self.layer.addSublayer(shapeLayer)
    }

    func drawDashedCircle(arcCenter: CGPoint, radius: CGFloat, lineWidth: CGFloat, value: CGFloat = 1.0, startAngle: CGFloat = -90.0, dashPattern: [CGFloat] = [1, 2], strokeColour: UIColor, hasShadow: Bool = false) {
        let pattern = dashPattern.map { NSNumber(value: Float($0)) }

        let angleStart = Math.radians(startAngle)
        let angleEnd = Math.radians(360 * value + startAngle)

        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius - lineWidth / 2, startAngle: angleStart, endAngle: angleEnd, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColour.cgColor
        shapeLayer.lineDashPattern = pattern

        if hasShadow {
            shapeLayer.addGlowEffect(color: strokeColour, shadowRadius: lineWidth + 2, shadowOpacity: 1)
        }

        self.layer.addSublayer(shapeLayer)
    }

    func drawAverageLine(center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, angle: CGFloat, lineWidth: CGFloat, strokeColour: UIColor) {
        let startPoint = Math.pointOnCircle(center: center, withRadius: innerRadius, andAngle: angle)
        let endPoint = Math.pointOnCircle(center: center, withRadius: outerRadius, andAngle: angle)

        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColour.cgColor
        self.layer.addSublayer(shapeLayer)
    }

    func drawSolidLine(from: CGPoint, to: CGPoint, lineWidth: CGFloat, strokeColour: UIColor) {
        let linePath = UIBezierPath()
        linePath.move(to: from)
        linePath.addLine(to: to)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColour.cgColor
        self.layer.addSublayer(shapeLayer)
    }

    func drawCapRoundLine(center: CGPoint, radius: CGFloat, value: CGFloat, startAngle: CGFloat = -90.0, lineWidth: CGFloat, strokeColour: UIColor) {
        let angleStart = Math.radians(startAngle)
        let angleEnd = Math.radians(360.0 * value + startAngle)

        let circlePath = UIBezierPath(arcCenter: center, radius: radius - lineWidth / 2, startAngle: angleStart, endAngle: angleEnd, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeColor = strokeColour.cgColor
        self.layer.addSublayer(shapeLayer)
    }

}
