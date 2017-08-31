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
    
    func drawSolidCircle(arcCenter: CGPoint,
                         radius: CGFloat,
                         lineWidth: CGFloat = 1,
                         value: CGFloat = 1,
                         startAngle: CGFloat = -90,
                         endAngle: CGFloat = 360,
                         strokeColour: UIColor = .white90,
                         clockwise: Bool = true) {
        drawCircle(center: arcCenter, radius: radius, lineWidth: lineWidth, value: value, startAngle: startAngle, endAngle: endAngle, color: strokeColour, clockwise: clockwise)
    }

    func drawDashedCircle(arcCenter: CGPoint,
                          radius: CGFloat,
                          lineWidth: CGFloat = 1,
                          dashPattern: [CGFloat] = [1, 2],
                          value: CGFloat = 1,
                          startAngle: CGFloat = -90,
                          endAngle: CGFloat = 360,
                          strokeColour: UIColor = .white20,
                          hasShadow: Bool = false) {
        let pattern = dashPattern.map { NSNumber(value: Float($0)) }
        drawCircle(center: arcCenter, radius: radius, lineWidth: lineWidth, value: value, startAngle: startAngle, endAngle: endAngle, color: strokeColour, dashPattern: pattern, hasShadow: hasShadow, shadowRadius: lineWidth + 2)
    }

    func drawCapRoundCircle(center: CGPoint,
                            radius: CGFloat,
                            value: CGFloat,
                            startAngle: CGFloat = -90,
                            endAngle: CGFloat = 360,
                            lineWidth: CGFloat,
                            strokeColour: UIColor) {
        drawCircle(center: center, radius: radius, lineWidth: lineWidth, lineCap: kCALineCapRound, value: value, startAngle: startAngle, endAngle: endAngle, color: strokeColour)
    }

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
                            shadowRadius: CGFloat = 0) {
        let path = circlePath(value: value, startAngle: startAngle, endAngle: endAngle, radius: radius, center: center, lineWidth: lineWidth, clockwise: clockwise)
        addShapeLayer(path: path, lineWidth: lineWidth, lineCap: lineCap, strokeColor: color, dashPattern: dashPattern, hasShadow: hasShadow, shadowRadius: shadowRadius)
        
    }

    // MARK: - Line

    func drawAverageLine(center: CGPoint,
                         innerRadius: CGFloat = 0,
                         outerRadius: CGFloat,
                         angle: CGFloat,
                         lineWidth: CGFloat = 1,
                         strokeColour: UIColor) {
        let startPoint = Math.pointOnCircle(center: center, withRadius: innerRadius, andAngle: angle)
        let endPoint = Math.pointOnCircle(center: center, withRadius: outerRadius, andAngle: angle)
        drawLine(from: startPoint, to: endPoint, lineWidth: lineWidth, strokeColor: strokeColour)
    }

    func drawSolidLine(from: CGPoint,
                       to: CGPoint,
                       lineWidth: CGFloat = 1,
                       strokeColour: UIColor = .white20,
                       hasShadow: Bool = false) {
        drawLine(from: from, to: to, lineWidth: lineWidth, strokeColor: strokeColour, hasShadow: hasShadow, shadowRadius: lineWidth * 0.5)
    }

    func drawDashedLine(from: CGPoint, to: CGPoint, lineWidth: CGFloat, strokeColour: UIColor, dashPattern: [CGFloat]) {
        let pattern = dashPattern.map { NSNumber(value: Float($0)) }
        drawLine(from: from, to: to, lineWidth: lineWidth, strokeColor: strokeColour, dashPattern: pattern)
    }

    func drawCapRoundLine(from: CGPoint, to: CGPoint, lineWidth: CGFloat, strokeColour: UIColor) {
        drawLine(from: from, to: to, lineWidth: lineWidth, lineCap: kCALineCapRound, strokeColor: strokeColour)
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
        addShapeLayer(path: path, lineWidth: lineWidth, lineCap: lineCap, strokeColor: strokeColor, dashPattern: dashPattern, hasShadow: hasShadow, shadowRadius: shadowRadius)
        
    }    

    func drawDottedColumns(columnWidth: CGFloat, columnHeight: CGFloat, rowHeight: CGFloat, columnCount: Int, rowCount: Int, strokeWidth: CGFloat, strokeColour: UIColor) {
        for x in 0..<columnCount {
            let columnX = CGFloat(frame.origin.x) + CGFloat(x) * columnWidth + strokeWidth * 0.5

            for y in 0..<rowCount {
                let columnY = CGFloat(frame.origin.y) + columnHeight - (CGFloat(y) * rowHeight) - rowHeight * 0.5
                let startPoint = CGPoint(x: columnX, y: columnY - strokeWidth * 0.5)
                let endPoint = CGPoint(x: columnX, y: columnY + strokeWidth * 0.5)
                drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth * 0.5, strokeColour: strokeColour)
            }
        }
    }

    func drawSolidColumns(columnWidth: CGFloat, columnHeight: CGFloat, columnCount: Int, strokeWidth: CGFloat, strokeColour: UIColor) {
        for x in 0...columnCount {
            let columnX = CGFloat(frame.origin.x) + CGFloat(x) * columnWidth + (x == columnCount ? -strokeWidth * 0.5 : strokeWidth * 0.5)
            let columnY = CGFloat(frame.origin.y) + columnHeight - strokeWidth * 0.5
            let startPoint = CGPoint(x: columnX, y: frame.origin.y)
            let endPoint = CGPoint(x: columnX, y: columnY)
            drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth * 0.5, strokeColour: strokeColour)
        }
    }

    func drawLabelsForColumns(labels: [String], columnCount: Int, textColour: UIColor, font: UIFont, center: Bool = false) {
        var lastLabel: UILabel? = nil

        for i in 0..<columnCount {
            let label = UILabel()
            label.text = labels[i]
            label.prepareAndSetTextAttributes(text: labels[i], font: font, alignment: (center ? .center : .natural))
            label.textColor = .white20
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

        guard let lbl = lastLabel else {
            return
        }

        lbl.trailingAnchor == self.trailingAnchor
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
                               shadowRadius: CGFloat = 0) {
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
    }
}
