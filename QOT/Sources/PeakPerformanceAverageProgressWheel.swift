//
//  PeakPerformanceAverageProgressWheel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 15/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PeakPerformanceAverageProgressWheel: UIView {

    private var pathColour: UIColor
    private var lineWidth: CGFloat
    private var wheelValue: CGFloat = 0
    private var teamValue: CGFloat = 0
    private var dataValue: CGFloat = 0
    private var dashPattern: [CGFloat]
    private var threshold: StatisticsThreshold<CGFloat>

    init(frame: CGRect, value: CGFloat = 0, teamValue: CGFloat = 0, dataValue: CGFloat = 0, threshold: StatisticsThreshold<CGFloat>, pathColor: UIColor, dashPattern: [CGFloat] = [1, 2], lineWidth: CGFloat = 5) {
        self.pathColour = pathColor
        self.lineWidth = lineWidth
        self.wheelValue = value
        self.teamValue = teamValue
        self.dataValue = dataValue
        self.threshold = threshold
        self.dashPattern = dashPattern

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
        let arcCenter = CGPoint(x: frame.width / 2, y: frame.height)
        let radius = CGFloat(frame.height * 0.8)
        let strokeColour = UIColor.white20
        let startAngle = CGFloat(-180)
        let endAngle = CGFloat(180)

        let strokeWidth: CGFloat = 1
        let innerRadius = radius * 0.5
        let outerRadius = radius - (lineWidth - strokeWidth) / 2
        let discRadius = radius * 0.1

        let startPoint = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height)
        let endPoint = CGPoint(x: self.frame.origin.x + self.frame.width, y: self.frame.origin.y + self.frame.height)

        drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: discRadius, lineWidth: discRadius, startAngle: startAngle, endAngle: endAngle, strokeColour: .brownishGrey)
        drawDashedCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: strokeWidth, startAngle: startAngle, endAngle: endAngle, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: strokeWidth, startAngle: startAngle, endAngle: endAngle, strokeColour: strokeColour)

        drawSolidCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, value: value, startAngle: startAngle, endAngle: endAngle, strokeColour: pathColour)

        // Draw zones
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: strokeWidth, value: 1 - threshold.upperThreshold, startAngle: 0, endAngle: startAngle, strokeColour: .cherryRed, clockwise: false)
    }
}
