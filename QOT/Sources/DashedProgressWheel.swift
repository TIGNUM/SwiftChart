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
    private var wheelValue: CGFloat = 0

    init(frame: CGRect, value: CGFloat = 0, pathColor: UIColor = .cherryRed, dashPattern: [CGFloat] = [1, 2], lineWidth: CGFloat = 15) {
        self.pathColour = pathColor
        self.dashPattern = dashPattern.map { NSNumber(value: Float($0)) }
        self.lineWidth = lineWidth
        self.wheelValue = value

        super.init(frame: frame)
        draw(frame: frame, value: value)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.removeAllSublayer()
        draw(frame: frame, value: wheelValue)
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
