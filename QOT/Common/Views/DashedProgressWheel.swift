//
//  DashedProgressWheel.swift
//  DashedProgressWheel
//
//  Created by Type-IT on 08.05.2017.
//  Copyright © 2017 Type-IT. All rights reserved.
//

import UIKit

class DashedProgressWheel: UIView {

    private var pathColour: UIColor
    private var lineWidth: CGFloat
    private var dashPattern: [NSNumber]
    private var wheelValue: CGFloat

    override init(frame: CGRect) {

        self.pathColour = UIColor.red
        self.lineWidth = 15.0
        self.dashPattern = [2, 4]
        self.wheelValue = 0

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {

        self.pathColour = UIColor.red
        self.lineWidth = 15.0
        self.dashPattern = [2, 4]
        self.wheelValue = 0

        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        draw(frame: frame, value: wheelValue)
    }

    func setup(value: CGFloat, newPathColor: UIColor, newDashPattern: [NSNumber], newLineWidth: CGFloat) {
        pathColour = newPathColor
        dashPattern = newDashPattern
        lineWidth = newLineWidth
        wheelValue = value

        draw(frame: frame, value: value)
    }

    private func draw(frame: CGRect, value: CGFloat) {

        let endValue = (360.0 * value) - 90

        let arcCenter = CGPoint(x: frame.height / 2, y: frame.width / 2)
        let radius = CGFloat(frame.width / 2 - lineWidth / 2)
        let startAngle = CGFloat(-90).radians()
        let endAngle = CGFloat(endValue).radians()
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = dashPattern

        shapeLayer.strokeColor = pathColour.cgColor

        self.layer.addSublayer(shapeLayer)
    }
}

extension CGFloat {
    func radians() -> CGFloat {
        let b = CGFloat(Float.pi) * (self/180)
        return b
    }
}
