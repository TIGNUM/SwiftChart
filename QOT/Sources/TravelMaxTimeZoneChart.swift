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

    private var statistics: Statistics
    private var labelContentView: UIView
    private let padding: CGFloat = 8
    private let strokeColor = UIColor.white20
    private let lineWidth: CGFloat = 5

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: frame)

        drawBackground()
        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TravelMaxTimeZoneChart {

    private func arcCenterPoint() -> CGPoint {
        return CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
    }

    private func radius() -> CGFloat {
        return (frame.height * 0.5) * 0.7
    }

    func drawCharts() {
        let circlePointRadius: CGFloat = lineWidth * 0.4
        let circlePointPositionRadius: CGFloat = radius() - lineWidth - circlePointRadius

        guard circlePointRadius > 0 else {
            return
        }

        let arcCenter = arcCenterPoint()
        let dataCenter = Math.pointOnCircle(center: arcCenter, withRadius: circlePointPositionRadius, andAngle: statistics.dataAngle)
        let teamCenter = Math.pointOnCircle(center: arcCenter, withRadius: circlePointPositionRadius, andAngle: statistics.teamAngle)

        drawCapRoundCircle(center: arcCenter, radius: radius(), value: statistics.userAverageValue, startAngle: -90, lineWidth: lineWidth, strokeColor: statistics.pathColor)
        drawSolidCircle(arcCenter: dataCenter, radius: circlePointRadius, lineWidth: circlePointRadius, value: 1, startAngle: -90, strokeColor: .cherryRed)
        drawSolidCircle(arcCenter: teamCenter, radius: circlePointRadius, lineWidth: circlePointRadius, value: 1, startAngle: -90, strokeColor: .azure)
    }

    func drawBackground() {
        let outerRadius = CGFloat(frame.height * 0.4)
        let dashPattern: [CGFloat] = [1, 1]
        let arcCenter = arcCenterPoint()
        let lineSemiLength = frame.height / 10
        let horizontalFrom = CGPoint(x: arcCenter.x - lineSemiLength, y: arcCenter.y)
        let horizontalTo = CGPoint(x: arcCenter.x + lineSemiLength, y: arcCenter.y)
        let verticalFrom = CGPoint(x: arcCenter.x, y: arcCenter.y - lineSemiLength)
        let verticalTo = CGPoint(x: arcCenter.x, y: arcCenter.y + lineSemiLength)

        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: 1, strokeColor: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius(), lineWidth: lineWidth, dashPattern: dashPattern, strokeColor: strokeColor)
        drawSolidLine(from: horizontalFrom, to: horizontalTo, lineWidth: 1, strokeColor: strokeColor)
        drawSolidLine(from: verticalFrom, to: verticalTo, lineWidth: 1, strokeColor: strokeColor)
    }
}
