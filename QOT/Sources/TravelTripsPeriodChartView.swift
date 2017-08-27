//
//  TravelTripsPeriodChartView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 16/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class TravelTripsPeriodChartView: UIView {

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

        layer.removeAllSublayer()
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
        drawDottedColumns(columnWidth: cellWidth, columnHeight: columnHeight, rowHeight: cellHeight, columnCount: columns, rowCount: rows, strokeWidth: strokeWidth, strokeColour: strokeColour)

        for period in data.periods {

            if isPeriodValid(period: period) {
                drawPeriods(period: period, cellWidth: cellWidth, cellHeight: cellHeight, strokeWidth: 4)
            }
        }
    }

    // MARK: - Draw methods

    private func drawPeriods(period: Period, cellWidth: CGFloat, cellHeight: CGFloat, strokeWidth: CGFloat) {
        let padding: CGFloat = 3
        let strokeColour = data.pathColor(forPeriod: period)
        let radius = strokeWidth / 2

        var remainingPeriod = period
        var isBeginning = true

        repeat {
            let calendar = Calendar.current
            let unitFlags = Set<Calendar.Component>([.hour, .day, .weekday, .weekOfYear, .month])
            var dateComponents = calendar.dateComponents(unitFlags, from: remainingPeriod.start)
            let nowComponents = calendar.dateComponents(unitFlags, from: Date())

            let column = getColumn(date: dateComponents, now: nowComponents) * cellWidth
            let startOffset = getColumnOffset(date: dateComponents, cellWidth: cellWidth - 3 * padding)

            let columnXStart = CGFloat(self.frame.origin.x) + column + startOffset + strokeWidth / 2 + padding
            let columnY = calculateRow(date: remainingPeriod.start, cellHeight: cellHeight, padding: padding, strokeWidth: strokeWidth)

            movePeriod(period: &remainingPeriod)
            dateComponents = calendar.dateComponents(unitFlags, from: remainingPeriod.start)
            let endOffset = getColumnOffset(date: dateComponents, cellWidth: cellWidth - 3 * padding, end: true)
            let columnXEnd = CGFloat(self.frame.origin.x) + column + endOffset + strokeWidth / 2 + padding

            movePeriod(period: &remainingPeriod, newDay: true)

            let start = CGPoint(x: columnXStart, y: columnY)
            let end = CGPoint(x: columnXEnd, y: columnY)

            drawCapRoundLine(from: start, to: end, lineWidth: strokeWidth, strokeColour: strokeColour.color)

            if isBeginning {
                drawSolidCircle(arcCenter: start, radius: radius, lineWidth: radius, strokeColour: strokeColour.secondaryColor)
                isBeginning = false
            }

            if remainingPeriod.duration <= 0 {
                drawSolidCircle(arcCenter: end, radius: radius, lineWidth: radius, strokeColour: strokeColour.secondaryColor)
            }

        } while remainingPeriod.duration > 0
    }

    // MARK: - Period related methods

    private func movePeriod(period: inout Period, newDay: Bool = false) {
        var intervalToAdd: TimeInterval = 0

        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.hour, .weekday])
        let dateComponents = calendar.dateComponents(unitFlags, from: period.start)

        switch data.displayType {
        case .weeks:
            guard let hour = dateComponents.hour else { break }
            var offset = data.statsPeriod().length - hour
            offset = offset == 0 ? data.statsPeriod().length : offset

            intervalToAdd = TimeInterval(offset * 3600)
        case .year:
            guard let weekday = dateComponents.weekday else { break }
            var offset = data.statsPeriod().length - weekday

            if offset == 0 {
                offset = newDay ? 1 : data.statsPeriod().length
            }

            intervalToAdd = TimeInterval(offset * 24 * 3600)
        default:
            break
        }

        if intervalToAdd > 0 {
            if period.duration < intervalToAdd {
                intervalToAdd = period.duration
            }
            period.start.addTimeInterval(intervalToAdd)
            period.duration -= intervalToAdd
        }
    }

    private func isPeriodValid(period: Period) -> Bool {
        var isValid = false

        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.hour, .day, .weekday, .weekOfYear, .month, .year])
        var dateComponents = calendar.dateComponents(unitFlags, from: period.start)
        let nowComponents = calendar.dateComponents(unitFlags, from: Date())

        switch data.displayType {
        case .weeks:
            let columnCount = data.statsPeriod().columns
            guard let dateWeek = dateComponents.weekOfYear else { return false }
            guard let nowWeek = nowComponents.weekOfYear else { return false }
            guard let dateYear = dateComponents.year else { return false }
            guard let nowYear = nowComponents.year else { return false }

            isValid = dateWeek >= nowWeek && dateYear == nowYear
            isValid = isValid || ((nowWeek + columnCount) % weeks(in: nowYear) >= dateWeek && dateYear == (nowYear + 1))
        case .year:
            guard let dateMonth = dateComponents.month else { return false }
            guard let nowMonth = nowComponents.month else { return false }
            guard let dateYear = dateComponents.year else { return false }
            guard let nowYear = nowComponents.year else { return false }

            isValid = dateMonth <= nowMonth && dateYear == nowYear
            isValid = isValid || (dateMonth > nowMonth && dateYear == (nowYear - 1))
        default:
            break
        }

        return isValid
    }

    private func weeks(in year: Int) -> Int {
        func p(_ year: Int) -> Int {
            return (year + year / 4 - year / 100 + year / 400) % 7
        }
        return (p(year) == 4 || p(year - 1) == 3) ? 53 : 52
    }

    // MARK: - Calculation methods

    // MARK: Y Calculation methods

    private func calculateRow(date: Date, cellHeight: CGFloat, padding: CGFloat, strokeWidth: CGFloat) -> CGFloat {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.weekday, .weekOfMonth])
        let dateComponents = calendar.dateComponents(unitFlags, from: date)

        var columnSubdivisions = 0

        switch data.displayType {
        case .weeks:
            guard let dateWeekday = dateComponents.weekday else { return 0 }
            columnSubdivisions = dateWeekday - 1
        case .year:
            guard let dateWeeks = dateComponents.weekOfMonth else { return 0 }
            columnSubdivisions = dateWeeks - 1
        default:
            return 0
        }
        let row = CGFloat(columnSubdivisions) * cellHeight + cellHeight / 2

        return CGFloat(self.frame.origin.y) + row
    }

    // MARK: X Calculation methods

    private func getColumn(date: DateComponents, now: DateComponents) -> CGFloat {
        switch data.displayType {
        case .weeks:
            let columnCount = data.statsPeriod().columns
            guard let dateWeek = date.weekOfYear else { return 0 }
            guard let nowWeek = now.weekOfYear else { return 0 }
            return CGFloat((dateWeek - nowWeek) % columnCount)
        case .year:
            let columnCount = data.statsPeriod().columns
            guard let dateMonth = date.month else { return 0 }
            guard let nowMonth = now.month else { return 0 }

            var column = (dateMonth - nowMonth) % columnCount
            column += column < 0 ? data.statsPeriod().columns : 0
            return CGFloat(column != 0 ? column : columnCount - 1)
        default:
            return 0
        }
    }

    private func getColumnOffset(date: DateComponents, cellWidth: CGFloat, end: Bool = false) -> CGFloat {
        switch data.displayType {
        case .weeks:
            let columnCount = data.statsPeriod().length
            guard let dateHour = date.hour else { return 0 }
            let hour = CGFloat(dateHour == 0 && end ? columnCount : dateHour)
            return CGFloat(cellWidth * hour / CGFloat(columnCount))
        case .year:
            let columnCount = data.statsPeriod().length
            guard let dateDay = date.weekday else { return 0 }
            return CGFloat(cellWidth * CGFloat(dateDay) / CGFloat(columnCount))
        default:
            return 0
        }
    }
}
