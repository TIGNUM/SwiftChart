//
//  TravelMaxTimeZoneChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class TravelMaxTimeZoneChart: UIView {

    // MARK: - Properties

    fileprivate var statistics: Statistics
    fileprivate var labelContentView: UIView
    fileprivate let padding: CGFloat = 8

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: frame)

        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TravelMaxTimeZoneChart {

    func drawCharts() {
        let lineWidth: CGFloat = 5
        let radius = CGFloat(frame.height * 0.5) * 0.7
        let circlePointRadius: CGFloat = lineWidth * 0.4
        let circlePointPositionRadius: CGFloat = radius - lineWidth - circlePointRadius

        guard circlePointRadius > 0 else {
            return
        }

        let dashPattern: [CGFloat] = [1, 1]
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let strokeColor = UIColor.white20
        let outerRadius = CGFloat(frame.height * 0.4)
        let dataCenter = Math.pointOnCircle(center: arcCenter, withRadius: circlePointPositionRadius, andAngle: statistics.dataAngle)
        let teamCenter = Math.pointOnCircle(center: arcCenter, withRadius: circlePointPositionRadius, andAngle: statistics.teamAngle)
        let lineSemiLength = frame.height / 10
        let horizontalFrom = CGPoint(x: arcCenter.x - lineSemiLength, y: arcCenter.y)
        let horizontalTo = CGPoint(x: arcCenter.x + lineSemiLength, y: arcCenter.y)
        let verticalFrom = CGPoint(x: arcCenter.x, y: arcCenter.y - lineSemiLength)
        let verticalTo = CGPoint(x: arcCenter.x, y: arcCenter.y + lineSemiLength)

        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: 1, strokeColor: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, strokeColor: strokeColor)
        drawCapRoundCircle(center: arcCenter, radius: radius, value: statistics.userAverageValue, startAngle: -90, lineWidth: lineWidth, strokeColor: statistics.pathColor)
        drawSolidCircle(arcCenter: dataCenter, radius: circlePointRadius, lineWidth: circlePointRadius, value: 1, startAngle: -90, strokeColor: .cherryRed)
        drawSolidCircle(arcCenter: teamCenter, radius: circlePointRadius, lineWidth: circlePointRadius, value: 1, startAngle: -90, strokeColor: .azure)
        drawSolidLine(from: horizontalFrom, to: horizontalTo, lineWidth: 1, strokeColor: strokeColor)
        drawSolidLine(from: verticalFrom, to: verticalTo, lineWidth: 1, strokeColor: strokeColor)
    }
}
