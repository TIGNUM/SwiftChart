//
//  DayEventChartView.swift
//  DashedProgressWheel
//
//  Created by Type-IT on 08.05.2017.
//  Copyright © 2017 Type-IT. All rights reserved.
//

import UIKit

final class DayEventChartView: UIView {

    private var events: [Event] = []
    private var lineWidth: CGFloat = 0

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        configure(events: self.events, lineWidth: self.lineWidth)
    }

    func configure(events: [Event], lineWidth: CGFloat) {

        self.events = events
        self.lineWidth = lineWidth

        for event in events {
            draw(frame: self.frame, startValue: event.start, endValue: event.end, lineWidth: lineWidth, color: event.color)
        }
    }

    private func draw(frame: CGRect, startValue: CGFloat, endValue: CGFloat, lineWidth: CGFloat, color: UIColor) {

        let start = (360.0 * startValue) - 90
        let end = (360.0 * endValue) - 90

        let arcCenter = CGPoint(x: frame.height / 2, y: frame.width / 2)
        let radius = CGFloat(frame.width / 2 - lineWidth / 2)
        let startAngle = CGFloat(start.radians())
        let endAngle = CGFloat(end.radians())
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.backgroundColor = UIColor.clear.cgColor

        self.layer.addSublayer(shapeLayer)
    }
}

struct Event {
    var start: CGFloat // A value between 0.0 & 1.0
    var end: CGFloat // A value between 0.0 & 1.0
    var color: UIColor
}
