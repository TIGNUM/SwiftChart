//
//  TravelTripsChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 16/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class TravelTripsChart: UIView {

    // MARK: - Properties

    fileprivate var statistics: Statistics
    fileprivate var labelContentView: UIView
    fileprivate let padding: CGFloat = 8

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))

        drawBackground()
        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TravelTripsChart {

    private var columns: Int {
        return statistics.chartType.statsPeriods.columns
    }

    private var rows: Int {
        return statistics.chartType.statsPeriods.rows
    }

    private var isWeeks: Bool {
        switch statistics.chartType {
        case .travelTripsAverageWeeks,
             .travelTripsTimeZoneChangedWeeks,
             .travelTripsNextFourWeeks: return true
        default: return false
        }
    }

    func drawCharts() {
        let columnWidth = frame.width / CGFloat(columns)
        let rowHeight = frame.height / CGFloat(isWeeks == true ? rows : 30)
        let lineWidth = rowHeight / (isWeeks == true ? 3 : 2)
        let singleStepUnit = (columnWidth - (columnWidth * 0.25)) / (24 * 60)

        statistics.travelTrips.forEach { (row: Int, column: Int, start: Int, end: Int, color: UIColor) in
            let xOffset = (CGFloat(row) * columnWidth) + (padding * 0.5)
            let yPosition = (rowHeight * CGFloat(column)) - padding
            let startXPosition = CGFloat(start) * singleStepUnit + xOffset
            let endXPosition = CGFloat(end) * singleStepUnit + xOffset
            let startPoint = CGPoint(x: startXPosition, y: yPosition)
            let endPoint = CGPoint(x: endXPosition, y: yPosition)

            drawCapRoundLine(from: startPoint, to: endPoint, lineWidth: lineWidth, strokeColor: color)
        }
    }

    func drawBackground() {
        let columnWidth = frame.width / CGFloat(columns)
        let rowHeight = frame.height / CGFloat(rows)

        drawDottedColumns(columnWidth: columnWidth,
                          columnHeight: frame.height,
                          rowHeight: rowHeight,
                          columnCount: columns,
                          rowCount: rows,
                          strokeWidth: 1,
                          strokeColor: .white80)
    }
}
