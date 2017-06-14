//
//  AverageMeetingProgressWheel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 12/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class AverageMeetingProgressWheel: UIView {

    private var pathColour: UIColor
    private var lineWidth: CGFloat
    private var wheelValue: CGFloat = 0
    private var teamValue: CGFloat = 0
    private var dataValue: CGFloat = 0
    private var dashPattern: [NSNumber]

    init(frame: CGRect, value: CGFloat = 0, teamValue: CGFloat = 0, dataValue: CGFloat = 0, pathColor: UIColor = .cherryRed, dashPattern: [CGFloat] = [1, 2], lineWidth: CGFloat = 5) {
        self.pathColour = pathColor
        self.lineWidth = lineWidth
        self.wheelValue = value
        self.teamValue = teamValue
        self.dataValue = dataValue
        self.dashPattern = dashPattern.map { NSNumber(value: Float($0)) }

        super.init(frame: frame)
        draw(frame: frame, value: value)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        draw(frame: frame, value: wheelValue)
    }

    private func draw(frame: CGRect, value: CGFloat) {
        let endValue = (360.0 * value) - 90
        let arcCenter = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = CGFloat(frame.height / 2)
        let startAngle = Math.radians(-90)
        let endAngle = Math.radians(endValue)
        let strokeColour = UIColor.white40

        let innerRadius = radius * 0.6
        let underRadius = radius

        drawInnerCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: 1, strokeColour: strokeColour)
        drawUnderCircle(arcCenter: arcCenter, radius: underRadius, lineWidth: lineWidth, strokeColour: strokeColour)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: radius, value: teamValue, lineWidth: 1, strokeColour: .azure)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: radius, value: dataValue, lineWidth: 1, strokeColour: .cherryRed)

        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius - lineWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeColor = pathColour.cgColor
        self.layer.addSublayer(shapeLayer)
    }

    private func drawAverageLine(center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, value: CGFloat, lineWidth: CGFloat, strokeColour: UIColor) {
        let angle = Math.radians(360 * value)
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

    private func drawInnerCircle(arcCenter: CGPoint, radius: CGFloat, lineWidth: CGFloat, strokeColour: UIColor = .white40) {
        let startAngle = Math.radians(0)
        let endAngle = Math.radians(360)
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius - lineWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColour.cgColor
        self.layer.addSublayer(shapeLayer)
    }

    private func drawUnderCircle(arcCenter: CGPoint, radius: CGFloat, lineWidth: CGFloat, strokeColour: UIColor = .white40) {
        let startAngle = Math.radians(0)
        let endAngle = Math.radians(360)
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius - lineWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColour.cgColor
        shapeLayer.lineDashPattern = dashPattern
        self.layer.addSublayer(shapeLayer)
    }
}
