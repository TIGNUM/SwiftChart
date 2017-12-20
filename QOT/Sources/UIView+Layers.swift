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

    // MARK: - Circle

    @discardableResult
    func drawSolidCircle(arcCenter: CGPoint,
                         radius: CGFloat,
                         lineWidth: CGFloat = 1,
                         value: CGFloat = 1,
                         startAngle: CGFloat = -90,
                         endAngle: CGFloat = 360,
                         strokeColor: UIColor = .white90,
                         clockwise: Bool = true) -> CALayer {
        return drawCircle(center: arcCenter, radius: radius, lineWidth: lineWidth, value: value, startAngle: startAngle, endAngle: endAngle, color: strokeColor, clockwise: clockwise)
    }

    @discardableResult
    func drawDashedCircle(arcCenter: CGPoint,
                          radius: CGFloat,
                          lineWidth: CGFloat = 1,
                          dashPattern: [CGFloat] = [1, 2],
                          value: CGFloat = 1,
                          startAngle: CGFloat = -90,
                          endAngle: CGFloat = 360,
                          strokeColor: UIColor = .white20,
                          hasShadow: Bool = false) -> CALayer {
        let pattern = dashPattern.map { NSNumber(value: Float($0)) }
        return drawCircle(center: arcCenter, radius: radius, lineWidth: lineWidth, value: value, startAngle: startAngle, endAngle: endAngle, color: strokeColor, dashPattern: pattern, hasShadow: hasShadow, shadowRadius: lineWidth + 2)
    }

    @discardableResult
    func drawCapRoundCircle(center: CGPoint,
                            radius: CGFloat,
                            value: CGFloat,
                            startAngle: CGFloat = -90,
                            endAngle: CGFloat = 360,
                            lineWidth: CGFloat,
                            strokeColor: UIColor) -> CALayer {
        return drawCircle(center: center, radius: radius, lineWidth: lineWidth, lineCap: kCALineCapRound, value: value, startAngle: startAngle, endAngle: endAngle, color: strokeColor)
    }

    // MARK: - Line

    func drawAverageLine(center: CGPoint,
                         innerRadius: CGFloat = 0,
                         outerRadius: CGFloat,
                         angle: CGFloat,
                         lineWidth: CGFloat = 1,
                         strokeColor: UIColor) {
        let startPoint = Math.pointOnCircle(center: center, withRadius: innerRadius, andAngle: angle)
        let endPoint = Math.pointOnCircle(center: center, withRadius: outerRadius, andAngle: angle)
        drawLine(from: startPoint, to: endPoint, lineWidth: lineWidth, strokeColor: strokeColor)
    }

    func drawSolidLine(from: CGPoint,
                       to: CGPoint,
                       lineWidth: CGFloat = 1,
                       strokeColor: UIColor = .white20,
                       hasShadow: Bool = false) {
        drawLine(from: from, to: to, lineWidth: lineWidth, strokeColor: strokeColor, hasShadow: hasShadow, shadowRadius: lineWidth * 0.5)
    }

    func drawDashedLine(from: CGPoint, to: CGPoint, lineWidth: CGFloat, strokeColor: UIColor, dashPattern: [CGFloat]) {
        let pattern = dashPattern.map { NSNumber(value: Float($0)) }
        drawLine(from: from, to: to, lineWidth: lineWidth, strokeColor: strokeColor, dashPattern: pattern)
    }

    func drawCapRoundLine(from: CGPoint, to: CGPoint, lineWidth: CGFloat, strokeColor: UIColor, hasShadow: Bool = false) {
        drawLine(from: from, to: to, lineWidth: lineWidth, lineCap: kCALineCapRound, strokeColor: strokeColor, hasShadow: hasShadow, shadowRadius: lineWidth * 2)
    }

    func drawDottedColumns(columnWidth: CGFloat, columnHeight: CGFloat, rowHeight: CGFloat, columnCount: Int, rowCount: Int, strokeWidth: CGFloat, strokeColor: UIColor) {
        for x in 0..<columnCount {
            let columnX = CGFloat(frame.origin.x) + CGFloat(x) * columnWidth + strokeWidth * 0.5

            for y in 0..<rowCount {
                let columnY = CGFloat(frame.origin.y) + columnHeight - (CGFloat(y) * rowHeight) - rowHeight * 0.5
                let startPoint = CGPoint(x: columnX, y: columnY - strokeWidth * 0.5)
                let endPoint = CGPoint(x: columnX, y: columnY + strokeWidth * 0.5)
                drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth * 0.5, strokeColor: strokeColor)
            }
        }
    }

    func drawSolidColumns(xPos: CGFloat,
                          columnWidth: CGFloat,
                          columnHeight: CGFloat,
                          columnCount: Int,
                          strokeWidth: CGFloat,
                          strokeColor: UIColor) {
        for x in 0...columnCount {
            let columnX = xPos + CGFloat(x) * columnWidth + (x == columnCount ? -strokeWidth * 0.5 : strokeWidth * 0.5)
            let columnY = frame.origin.y + columnHeight - strokeWidth * 0.5
            let startPoint = CGPoint(x: columnX, y: frame.origin.y)
            let endPoint = CGPoint(x: columnX, y: columnY)
            drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth * 0.5, strokeColor: strokeColor)
        }
    }

    func drawLabelsForColumns(labels: [String], textColor: UIColor, highlightColor: UIColor, font: UIFont, center: Bool = false) {
        var lastLabel: UILabel? = nil

        for index in 0..<labels.count {
            let label = UILabel()
            label.text = labels[index]
            let color = index == labels.endIndex - 1 ? highlightColor : textColor
            label.setAttrText(text: labels[index], font: font, alignment: (center ? .center : .natural), color: color)
            addSubview(label)
            label.topAnchor == topAnchor
            label.bottomAnchor == bottomAnchor

            breakLabel:
                do {
                    guard let lastLbl = lastLabel else {
                        label.leadingAnchor == leadingAnchor
                        break breakLabel
                    }
                    lastLbl.trailingAnchor == label.leadingAnchor
                    label.widthAnchor == lastLbl.widthAnchor
            }

            lastLabel = label
        }

        guard let label = lastLabel else { return }

        label.trailingAnchor == trailingAnchor
    }

    // MARK: - private

    private func drawCircle(center: CGPoint,
                            radius: CGFloat,
                            lineWidth: CGFloat,
                            lineCap: String = kCALineCapButt,
                            value: CGFloat,
                            startAngle: CGFloat,
                            endAngle: CGFloat,
                            color: UIColor,
                            clockwise: Bool = true,
                            dashPattern: [NSNumber]? = nil,
                            hasShadow: Bool = false,
                            shadowRadius: CGFloat = 0) -> CALayer {
        let path = circlePath(value: value, startAngle: startAngle, endAngle: endAngle, radius: radius, center: center, lineWidth: lineWidth, clockwise: clockwise)
        return addShapeLayer(path: path, lineWidth: lineWidth, lineCap: lineCap, strokeColor: color, dashPattern: dashPattern, hasShadow: hasShadow, shadowRadius: shadowRadius)
    }

    private func drawLine(from: CGPoint,
                          to: CGPoint,
                          lineWidth: CGFloat,
                          lineCap: String = kCALineCapButt,
                          strokeColor: UIColor,
                          dashPattern: [NSNumber]? = nil,
                          hasShadow: Bool = false,
                          shadowRadius: CGFloat = 0) {
        let path = linePath(from: from, to: to)
        _ = addShapeLayer(path: path, lineWidth: lineWidth, lineCap: lineCap, strokeColor: strokeColor, dashPattern: dashPattern, hasShadow: hasShadow, shadowRadius: shadowRadius)
    }

    private func linePath(from: CGPoint, to: CGPoint) -> UIBezierPath {
        let linePath = UIBezierPath()
        linePath.move(to: from)
        linePath.addLine(to: to)
        return linePath
    }

    private func circlePath(value: CGFloat, startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat, center: CGPoint, lineWidth: CGFloat, clockwise: Bool) -> UIBezierPath {
        let angleStart = startAngle.degreesToRadians
        let angleEnd = (endAngle * value + startAngle).degreesToRadians
        let circleRadius = radius - lineWidth * 0.5
        return UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: angleStart, endAngle: angleEnd, clockwise: clockwise)
    }

    private func addShapeLayer(path: UIBezierPath,
                               lineWidth: CGFloat,
                               lineCap: String = kCALineCapButt,
                               strokeColor: UIColor,
                               dashPattern: [NSNumber]? = nil,
                               hasShadow: Bool = false,
                               shadowRadius: CGFloat = 0) -> CALayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.lineCap = lineCap

        if hasShadow == true {
            shapeLayer.addGlowEffect(color: strokeColor, shadowRadius: shadowRadius, shadowOpacity: 1)
        }

        layer.addSublayer(shapeLayer)
        return shapeLayer
    }
}
