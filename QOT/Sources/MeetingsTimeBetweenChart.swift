//
//  MeetingsTimeBetweenChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MeetingsTimeBetweenChart: UIView {

    // MARK: - Properties

    private var statistics: Statistics
    private var labelContentView: UIView
    private let padding: CGFloat = 8

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: frame)

        drawProgressWheel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension MeetingsTimeBetweenChart {

    func drawProgressWheel() {
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let radius = CGFloat(frame.height * 0.4)
        let strokeColor = UIColor.white20
        let lineWidth = CGFloat(12)
        let dashPattern: [CGFloat] = [1, 1]
        let innerRadius = radius * 0.6
        let underRadius = radius - lineWidth / 3

        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, strokeColor: strokeColor)
        drawSolidCircle(arcCenter: arcCenter, radius: underRadius, lineWidth: lineWidth * 0.5, strokeColor: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, value: statistics.userAverageValue, strokeColor: statistics.pathColor)
        drawAverageLine(center: arcCenter, outerRadius: radius, angle: statistics.teamAngle, strokeColor: .azure)
        drawAverageLine(center: arcCenter, outerRadius: radius, angle: statistics.dataAngle, strokeColor: .cherryRed)
        drawAverageLine(center: arcCenter, outerRadius: radius, angle: CGFloat(-90).degreesToRadians, strokeColor: strokeColor)
        drawAverageLine(center: arcCenter, outerRadius: radius, angle: statistics.userAngle, strokeColor: strokeColor)
    }
}
