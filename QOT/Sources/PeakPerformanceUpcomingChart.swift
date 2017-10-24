//
//  PeakPerformanceUpcomingChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 20/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PeakPerformanceUpcomingChart: UIView {

    // MARK: - Properties

    fileprivate var statistics: Statistics
    fileprivate var labelContentView: UIView
    fileprivate let padding: CGFloat = 8

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

private extension PeakPerformanceUpcomingChart {

    private var rows: Int {
        return statistics.chartType.statsPeriods.rows
    }

    private var rowWidth: CGFloat {
        return frame.width / CGFloat(rows)
    }

    func drawCharts() {
        let singleStepUnit = frame.height / (24 * 60)
        let lineWidth = rowWidth / 3
        let currentPeriod = statistics.chartType == .peakPerformanceUpcomingWeek ? statistics.periodLastWeek : statistics.periodNextWeek

        for (index, periodsInOneDay) in currentPeriod.enumerated() {
            let xPos = xPosition(index)

            periodsInOneDay.forEach { (period: StatisticsPeriod) in
                let startPoint = CGPoint(x: xPos, y: CGFloat(period.startMinute) * singleStepUnit)
                let endPoint = CGPoint(x: xPos, y: CGFloat(period.startMinute + period.minutes) * singleStepUnit)
                let strokeColor = period.status.color
                let hasShadow = period.status == .normal

                drawSolidLine(from: startPoint, to: endPoint, lineWidth: lineWidth, strokeColor: strokeColor, hasShadow: hasShadow)
            }
        }
    }

    func drawBackground() {
        drawSolidColumns(columnWidth: rowWidth,
                         columnHeight: frame.height,
                         columnCount: rows,
                         strokeWidth: 1,
                         strokeColor: .white20)
    }

    func xPosition(_ index: Int) -> CGFloat {
        guard labelContentView.subviews.count >= index else {
            return 0
        }

        let labelFrame = labelContentView.subviews[index].frame

        return (labelFrame.origin.x + labelFrame.width * 0.5)
    }
}
