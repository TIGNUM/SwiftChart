//
//  MeetingsAverageChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 12/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MeetingsAverageChart: UIView {

    // MARK: - Properties

    fileprivate var statistics: Statistics
    fileprivate var labelContentView: UIView
    fileprivate let padding: CGFloat = 8

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))

        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension MeetingsAverageChart {

    func drawCharts() {
        let lineWidth: CGFloat = 5
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let radius = CGFloat(frame.height * 0.4)
        let innerRadius = radius * 0.6
        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: 1, strokeColor: .white20)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: [1, 1], strokeColor: .white20)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: radius, angle: statistics.teamAngle, lineWidth: 1, strokeColor: .azure)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: radius, angle: statistics.dataAngle, lineWidth: 1, strokeColor: .cherryRed)
        drawCapRoundCircle(center: arcCenter, radius: radius, value: statistics.userAverageValue, lineWidth: lineWidth, strokeColor: statistics.pathColor)
    }
}
