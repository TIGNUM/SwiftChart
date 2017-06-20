//
//  PeakPerformanceUpcomingChartView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 20/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PeakPerformanceUpcomingChartView: UIView {

    private var data: MyStatisticsDataPeriods

    init(frame: CGRect, data: MyStatisticsDataPeriods) {
        self.data = data

        super.init(frame: frame)
        draw(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        draw(frame: frame)
    }

    private func draw(frame: CGRect) {
        let strokeColour = UIColor.white20
        let strokeWidth = CGFloat(1.0)
        let columns = data.statsPeriod().columns
        let rows = data.statsPeriod().rows
        let cellWidth = self.frame.width / CGFloat(columns)
        let cellHeight = self.frame.height / CGFloat(rows)
        let columnHeight = self.frame.height

        let startPoint = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + columnHeight)
        let endPoint = CGPoint(x: self.frame.origin.x + self.frame.width, y: self.frame.origin.y + columnHeight)

        drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth, strokeColour: strokeColour)
        drawSolidColumns(columnWidth: cellWidth, columnHeight: columnHeight, columnCount: columns, strokeWidth: strokeWidth, strokeColour: strokeColour)

        for period in data.periods {

            if isPeriodValid(period: period) {
                drawPeriods(period: period, cellWidth: cellWidth, cellHeight: cellHeight, strokeWidth: cellWidth / 3)
            }
        }
    }

    // MARK: - Draw methods

    private func drawPeriods(period: Period, cellWidth: CGFloat, cellHeight: CGFloat, strokeWidth: CGFloat) {
        let padding: CGFloat = 3
        let strokeColour = data.pathColor(forPeriod: period)

        var remainingPeriod = period

        repeat {
            let calendar = Calendar.current
            let unitFlags = Set<Calendar.Component>([.hour, .day, .weekday, .weekOfYear, .month])
            var dateComponents = calendar.dateComponents(unitFlags, from: remainingPeriod.start)

            var columnX: CGFloat = 0
            if let weekday = dateComponents.weekday {
                columnX = CGFloat(weekday - 1) * cellWidth + cellWidth / 2
            }

//                CGFloat(self.frame.origin.x) + column + startOffset + strokeWidth / 2 + padding
            let columnYStart = getRow(date: dateComponents, cellHeight: cellHeight) + padding

            movePeriod(period: &remainingPeriod)
            dateComponents = calendar.dateComponents(unitFlags, from: remainingPeriod.start)
            let columnYEnd = getRow(date: dateComponents, cellHeight: cellHeight, end: true) - padding
//            let endOffset = getColumnOffset(date: dateComponents, cellWidth: cellWidth - 3 * padding, end: true)
//            let columnYEnd = CGFloat(self.frame.origin.x) + column + endOffset + strokeWidth / 2 + padding

//            movePeriod(period: &remainingPeriod, newDay: true)

            let start = CGPoint(x: columnX, y: columnYStart)
            let end = CGPoint(x: columnX, y: columnYEnd)

            drawSolidLine(from: start, to: end, lineWidth: strokeWidth, strokeColour: strokeColour.color, hasShadow: strokeColour == .below)
//            drawCapRoundLine(from: start, to: end, lineWidth: strokeWidth, strokeColour: strokeColour.color)
        } while remainingPeriod.duration > 0
    }

    // MARK: - Period related methods

    private func movePeriod(period: inout Period, newDay: Bool = false) {
        var intervalToAdd = 0

        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.hour])
        let dateComponents = calendar.dateComponents(unitFlags, from: period.start)

        switch data.displayType {
        case .lastWeek:
            fallthrough
        case .nextWeek:
            guard let hour = dateComponents.hour else { break }
            var offset = data.statsPeriod().rows - hour
            offset = offset == 0 ? data.statsPeriod().rows : offset

            intervalToAdd = offset * data.statsPeriod().length
        default:
            break
        }

        if intervalToAdd > 0 {
            let duration = Int(period.duration)
            if duration < intervalToAdd {
                intervalToAdd = duration
            }
            intervalToAdd += (intervalToAdd % data.statsPeriod().length)
            let interval = TimeInterval(intervalToAdd)
            period.start.addTimeInterval(interval)
            period.duration -= interval
        }
    }

    private func isPeriodValid(period: Period) -> Bool {
        var interval: TimeInterval = 0
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.weekOfYear, .year])
        let nowComponents = calendar.dateComponents(unitFlags, from: Date())

        switch data.displayType {
        case .lastWeek:
            interval = TimeInterval(data.statsPeriod().columns * data.statsPeriod().rows * data.statsPeriod().length)
        case .nextWeek:
            interval = TimeInterval(data.statsPeriod().columns * data.statsPeriod().rows * -data.statsPeriod().length)
        default:
            return false
        }

        var dateComponents = calendar.dateComponents(unitFlags, from: period.start.addingTimeInterval(interval))

        guard let dateWeek = dateComponents.weekOfYear else { return false }
        guard let nowWeek = nowComponents.weekOfYear else { return false }
        guard let dateYear = dateComponents.year else { return false }
        guard let nowYear = nowComponents.year else { return false }

        return dateWeek == nowWeek && dateYear == nowYear
    }

    // MARK: - Calculation methods

    private func getRow(date: DateComponents, cellHeight: CGFloat, end: Bool = false) -> CGFloat {
        switch data.displayType {
        case .lastWeek:
            fallthrough
        case .nextWeek:
            let rowCount = data.statsPeriod().rows
            guard let dateHour = date.hour else { return 0 }
            let hour = CGFloat(dateHour == 0 && end ? rowCount : dateHour)
            return CGFloat(cellHeight * hour)
        default:
            return 0
        }
    }
}
