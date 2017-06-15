//
//  AverageMeetingLengthViewProgressWheel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class AverageMeetingLengthProgressWheel: UIView {

    private var pathColour: UIColor
    private var lineWidth: CGFloat
    private var wheelValue: CGFloat = 0
    private var teamValue: CGFloat = 0
    private var dataValue: CGFloat = 0
    private var dashPattern: [CGFloat]

    init(frame: CGRect, value: CGFloat = 0, teamValue: CGFloat = 0, dataValue: CGFloat = 0, pathColor: UIColor, dashPattern: [CGFloat] = [1, 1], lineWidth: CGFloat = 5) {
        self.pathColour = pathColor
        self.lineWidth = lineWidth
        self.wheelValue = value
        self.teamValue = teamValue
        self.dataValue = dataValue
        self.dashPattern = dashPattern

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
        let arcCenter = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = CGFloat(frame.height / 2) * 0.75
        let strokeColour = UIColor.white20

        let innerRadius = radius * 0.6
        let outerRadius = CGFloat(frame.height / 2)

        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: 1, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: 1, strokeColour: strokeColour)

        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, strokeColour: strokeColour)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, value: value, strokeColour: pathColour, hasShadow: true)

        let dataAngle = Math.radians(360 * dataValue - 90)
        let teamAngle = Math.radians(360 * teamValue - 90)

        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: outerRadius, angle: teamAngle, lineWidth: 1, strokeColour: .azure)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: outerRadius, angle: dataAngle, lineWidth: 1, strokeColour: .cherryRed)

        let lineSemiLength = frame.height / 10
        let horizontalFrom = CGPoint(x: arcCenter.x - lineSemiLength, y: arcCenter.y)
        let horizontalTo = CGPoint(x: arcCenter.x + lineSemiLength, y: arcCenter.y)
        let verticalFrom = CGPoint(x: arcCenter.x, y: arcCenter.y - lineSemiLength)
        let verticalTo = CGPoint(x: arcCenter.x, y: arcCenter.y + lineSemiLength)

        drawSolidLine(from: horizontalFrom, to: horizontalTo, lineWidth: 1, strokeColour: strokeColour)
        drawSolidLine(from: verticalFrom, to: verticalTo, lineWidth: 1, strokeColour: strokeColour)
    }
}
