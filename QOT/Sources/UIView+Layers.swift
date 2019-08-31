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

    // MARK: - Shadows

    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

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

    func drawLabelsForColumns(titles: [String], textColor: UIColor, highlightColor: UIColor, font: UIFont, center: Bool = false, highlightedIndex: Int?) {
        var lastCreatedLabel: UILabel? = nil
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            let highlightedIndex = highlightedIndex ?? titles.endIndex - 1
            let color = index == highlightedIndex ? highlightColor : textColor
            label.setAttrText(text: titles[index], font: font, alignment: (center ? .center : .natural), color: color)
            addSubview(label)
            label.topAnchor == topAnchor
            label.bottomAnchor == bottomAnchor

            if let lastLabel = lastCreatedLabel {
                label.leadingAnchor == lastLabel.trailingAnchor
                label.widthAnchor == lastLabel.widthAnchor
            } else {
                label.leadingAnchor == leadingAnchor
            }
            if index == titles.count - 1 {
                label.trailingAnchor == trailingAnchor
            }
            lastCreatedLabel = label
        }
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

extension UIView {

    func maskCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func maskPathByRoundingCorners() {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight],
                                    cornerRadii: CGSize(width: 10.0, height: 10.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
}

extension UIView {

    func corner(radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat = 1) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }

    func corner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func circle() {
        corner(radius: frame.height * 0.5)
    }

    func cornerDefault() {
        corner(radius: 20)
    }

    func animateHidden(_ hidden: Bool, duration: TimeInterval = 0.5) {
        guard hidden != isHidden else { return }
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    }
}

extension UIView {

    func withGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.charcoal.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.2]
        layer.addSublayer(gradient)
    }
}

extension UIView {

    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if image != nil {
            return image!
        }
        return UIImage()
    }
}
