//
//  PolygonChart.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SleepChartView: UIView {

    fileprivate var outerPolygonShape = CAShapeLayer()
    fileprivate var innerPolygonShape = CAShapeLayer()
    fileprivate var centerPolygonShape = CAShapeLayer()
    fileprivate var lineHeight = [CGFloat]()
    fileprivate var LineColor = [UIColor]()

    func setUp(borderColor: UIColor, sides: Int, lineWidth: CGFloat, roundLine: Bool, averageValue: CGFloat, lineHeight: [CGFloat], lineColor: [UIColor]) {
        self.lineHeight = lineHeight
        self.LineColor = lineColor
        lineBounds(rect: bounds, lineWidth: lineWidth, sides: sides, roundCap: roundLine)
        drawShape(borderColor: borderColor, sides: sides)
        configureInnerPolygon(averageValue: averageValue)
    }

    private func drawShape(borderColor: UIColor, borderWidth: CGFloat = 1, sides: Int) {
        outerPolygonShape = shape(borderColor: borderColor)
        outerPolygonShape.path = UIBezierPath.roundedPolygonPath(rect: bounds, lineWidth: borderWidth, sides: 5).cgPath

        innerPolygonShape = shape(borderColor: borderColor)
        centerPolygonShape = shape(borderColor: borderColor, fillColor: .brown)
        centerPolygonShape.path = UIBezierPath.roundedPolygonPath(rect: bounds, lineWidth: borderWidth, sides: sides, radius: 10).cgPath

        layer.addSublayer(innerPolygonShape)
        layer.addSublayer(outerPolygonShape)
        layer.addSublayer(centerPolygonShape)
    }

    private func shape(borderColor: UIColor, fillColor: UIColor = .clear) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = borderColor.cgColor
        shape.fillColor = fillColor.cgColor
        return shape
    }

    func configureInnerPolygon(averageValue: CGFloat = 0.5) {
        let radius = (bounds.width / 2) * averageValue
        innerPolygonShape.path = UIBezierPath.roundedPolygonPath(rect: bounds, lineWidth: 1, sides: 5, radius: radius).cgPath
    }

    private func drawLines(roundCap: Bool, center: CGPoint, end: CGPoint, color: UIColor) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: center)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.lineWidth = 4
        line.lineDashPattern = [1.5, 1]
        if roundCap == true {
            line.lineCap = kCALineCapRound
        }
        line.strokeColor = color.cgColor
        layer.addSublayer(line)
    }

    private func lineBounds(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, roundCap: Bool) {

        if lineHeight.count <= 0 {
            fatalError("Please set the value for Lines")
        }

        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(sides)
        let width = min(rect.size.width, rect.size.height)
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        var angle = rotationOffset

        for index in 0..<sides {
            angle += theta
            let length = (bounds.width / 2.2 ) * lineHeight[index]
            let corner = CGPoint(x: center.x + ( length ) * cos(angle), y: center.y + (length ) * sin(angle))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            drawLines(roundCap: roundCap, center: center, end: end, color: LineColor[index])
        }
}
}
