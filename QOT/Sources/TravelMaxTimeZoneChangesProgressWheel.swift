//
//  TravelMaxTimeZoneChangesProgressWheel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class TravelMaxTimeZoneChangesProgressWheel: UIView {

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
        let radius = CGFloat(frame.height / 2) * 0.9
        let strokeColour = UIColor.white20

        let outerRadius = CGFloat(frame.height / 2)

        let circlePointRadius: CGFloat = lineWidth / 2
        let circlePointPositionRadius: CGFloat = radius - lineWidth - circlePointRadius
        if circlePointRadius < 0 { return }

        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: 1, strokeColour: strokeColour)

        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, strokeColour: strokeColour)
        drawCapRoundLine(center: arcCenter, radius: radius, value: value, startAngle: -90, lineWidth: lineWidth, strokeColour: pathColour)

        let dataAngle = Math.radians(360 * dataValue - 90)
        let teamAngle = Math.radians(360 * teamValue - 90)

        let dataCenter = Math.pointOnCircle(center: arcCenter, withRadius: circlePointPositionRadius, andAngle: dataAngle)
        let teamCenter = Math.pointOnCircle(center: arcCenter, withRadius: circlePointPositionRadius, andAngle: teamAngle)

        drawSolidCircle(arcCenter: dataCenter, radius: circlePointRadius, lineWidth: circlePointRadius, value: 1, startAngle: -90, strokeColour: .cherryRed)
        drawSolidCircle(arcCenter: teamCenter, radius: circlePointRadius, lineWidth: circlePointRadius, value: 1, startAngle: -90, strokeColour: .azure)

        let lineSemiLength = frame.height / 10
        let horizontalFrom = CGPoint(x: arcCenter.x - lineSemiLength, y: arcCenter.y)
        let horizontalTo = CGPoint(x: arcCenter.x + lineSemiLength, y: arcCenter.y)
        let verticalFrom = CGPoint(x: arcCenter.x, y: arcCenter.y - lineSemiLength)
        let verticalTo = CGPoint(x: arcCenter.x, y: arcCenter.y + lineSemiLength)

        drawSolidLine(from: horizontalFrom, to: horizontalTo, lineWidth: 1, strokeColour: strokeColour)
        drawSolidLine(from: verticalFrom, to: verticalTo, lineWidth: 1, strokeColour: strokeColour)
    }
}
