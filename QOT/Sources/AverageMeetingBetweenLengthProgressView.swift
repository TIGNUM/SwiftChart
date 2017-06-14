//
//  AverageMeetingBetweenLengthProgressView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class AverageMeetingBetweenLengthProgressWheel: UIView {

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
        let radius = CGFloat(frame.height / 2)
        let strokeColour = UIColor.white20

        let innerRadius = radius * 0.6
        let underRadius = radius - lineWidth / 3

        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: 1, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: underRadius, lineWidth: lineWidth / 2, strokeColour: strokeColour)

        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, strokeColour: pathColour, value: value)

        let dataAngle = Math.radians(360 * dataValue - 90)
        let teamAngle = Math.radians(360 * teamValue - 90)

        let userAngleStart = Math.radians(-90)
        let userAngleEnd = Math.radians(360 * value - 90)

        drawAverageLine(center: arcCenter, innerRadius: 0, outerRadius: radius, angle: teamAngle, lineWidth: 1, strokeColour: .azure)
        drawAverageLine(center: arcCenter, innerRadius: 0, outerRadius: radius, angle: dataAngle, lineWidth: 1, strokeColour: .cherryRed)

        drawAverageLine(center: arcCenter, innerRadius: 0, outerRadius: radius, angle: userAngleStart, lineWidth: 1, strokeColour: strokeColour)
        drawAverageLine(center: arcCenter, innerRadius: 0, outerRadius: radius, angle: userAngleEnd, lineWidth: 1, strokeColour: strokeColour)

    }

}
