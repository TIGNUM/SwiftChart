//
//  UIView+Layers.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

extension UIView {
    func drawSolidCircle(arcCenter: CGPoint, radius: CGFloat, lineWidth: CGFloat, value: CGFloat = 1.0, startAngle: CGFloat = -90.0, endAngle: CGFloat = 360.0, strokeColour: UIColor, clockwise: Bool = true) {
        let angleStart = Math.radians(startAngle)
        let angleEnd = Math.radians(endAngle * value + startAngle)

        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius - lineWidth / 2, startAngle: angleStart, endAngle: angleEnd, clockwise: clockwise)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColour.cgColor

        self.layer.addSublayer(shapeLayer)
    }

    func drawDashedCircle(arcCenter: CGPoint, radius: CGFloat, lineWidth: CGFloat, dashPattern: [CGFloat] = [1, 2], value: CGFloat = 1.0, startAngle: CGFloat = -90.0, endAngle: CGFloat = 360.0, strokeColour: UIColor, hasShadow: Bool = false) {
        let pattern = dashPattern.map { NSNumber(value: Float($0)) }

        let angleStart = Math.radians(startAngle)
        let angleEnd = Math.radians(endAngle * value + startAngle)

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

    func drawDashedLine(from: CGPoint, to: CGPoint, lineWidth: CGFloat, strokeColour: UIColor, dashPattern: [CGFloat]) {
        let pattern = dashPattern.map { NSNumber(value: Float($0)) }

        let linePath = UIBezierPath()
        linePath.move(to: from)
        linePath.addLine(to: to)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColour.cgColor
        shapeLayer.lineDashPattern = pattern
        self.layer.addSublayer(shapeLayer)
    }

    func drawCapRoundLine(from: CGPoint, to: CGPoint, lineWidth: CGFloat, strokeColour: UIColor) {
        let linePath = UIBezierPath()
        linePath.move(to: from)
        linePath.addLine(to: to)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeColor = strokeColour.cgColor
        self.layer.addSublayer(shapeLayer)
    }

    func drawCapRoundCircle(center: CGPoint, radius: CGFloat, value: CGFloat, startAngle: CGFloat = -90.0, endAngle: CGFloat = 360.0, lineWidth: CGFloat, strokeColour: UIColor) {
        let angleStart = Math.radians(startAngle)
        let angleEnd = Math.radians(endAngle * value + startAngle)

        let circlePath = UIBezierPath(arcCenter: center, radius: radius - lineWidth / 2, startAngle: angleStart, endAngle: angleEnd, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeColor = strokeColour.cgColor
        self.layer.addSublayer(shapeLayer)
    }

    func drawColumns(columnWidth: CGFloat, columnHeight: CGFloat, rowHeight: CGFloat, columnCount: Int, rowCount: Int, strokeWidth: CGFloat, strokeColour: UIColor) {

        for x in 0..<columnCount {
            let columnX = CGFloat(self.frame.origin.x) + CGFloat(x) * columnWidth + strokeWidth / 2
            for y in 0..<rowCount {
                let columnY = CGFloat(self.frame.origin.y) + columnHeight - (CGFloat(y) * rowHeight) - rowHeight / 2
                let startPoint = CGPoint(x: columnX, y: columnY - strokeWidth / 2)
                let endPoint = CGPoint(x: columnX, y: columnY + strokeWidth / 2)

                drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth / 2, strokeColour: strokeColour)
            }
        }
    }
    
    func drawLabelsForColumns(labels: [String], columnCount: Int, textColour: UIColor, font: UIFont) {
        var lastLabel: UILabel? = nil

        for i in 0..<columnCount {
            let label = UILabel()
            label.text = labels[i]

            label.prepareAndSetTextAttributes(text: labels[i], font: font)
            label.textColor = .white20

            addSubview(label)

            label.topAnchor == self.topAnchor
            label.bottomAnchor == self.bottomAnchor

            breakLabel:
                do {
                    guard let lastLbl = lastLabel else {
                        label.leadingAnchor == self.leadingAnchor
                        break breakLabel
                    }
                    lastLbl.trailingAnchor == label.leadingAnchor
                    label.widthAnchor == lastLbl.widthAnchor
            }

            lastLabel = label
        }
        guard let lbl = lastLabel else { return }
        lbl.trailingAnchor == self.trailingAnchor
    }
}
