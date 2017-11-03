//
//  PeakPerformanceAverageChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 15/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PeakPerformanceAverageChart: UIView {

    // MARK: - Properties

    private var statistics: Statistics
    private var labelContentView: UIView
    private let padding: CGFloat = 8

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

private extension PeakPerformanceAverageChart {

    func drawCharts() {
        let lineWidth = CGFloat(10)
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height)
        let radius = CGFloat(frame.width * 0.5)
        let strokeColor = UIColor.white20
        let startAngle = CGFloat(-180)
        let endAngle = CGFloat(180)
        let strokeWidth: CGFloat = 1
        let innerRadius = radius * 0.5
        let outerRadius = radius - (lineWidth - strokeWidth) * 0.5
        let discRadius = radius * 0.1
        let userAverage = statistics.userAverage < statistics.maximum ? statistics.userAverageValue : CGFloat(1)
        let start = CGPoint(x: 0, y: frame.height)
        let end = CGPoint(x: frame.width, y: frame.height)

        drawSolidLine(from: start, to: end, lineWidth: 0.5, strokeColor: .white20)
        drawAverageLine(center: arcCenter, outerRadius: outerRadius, angle: (endAngle * userAverage + startAngle).degreesToRadians, strokeColor: UIColor.white8)
        drawDashedCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: strokeWidth, startAngle: startAngle, endAngle: endAngle, strokeColor: strokeColor)
        drawSolidCircle(arcCenter: arcCenter, radius: discRadius, lineWidth: discRadius, startAngle: startAngle, endAngle: endAngle, strokeColor: .brownishGrey)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: strokeWidth, startAngle: startAngle, endAngle: endAngle, strokeColor: strokeColor)
        drawSolidCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, value: userAverage, startAngle: startAngle, endAngle: endAngle, strokeColor: statistics.pathColor)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: strokeWidth, value: statistics.dataAverageValue, startAngle: 0, endAngle: startAngle, strokeColor: .cherryRed, clockwise: false)
    }
}
