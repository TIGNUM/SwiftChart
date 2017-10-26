//
//  Statistics.swift
//  QOT
//
//  Created by karmic on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class Statistics: SyncableObject {

    @objc fileprivate(set) dynamic var key: String = ""

    @objc fileprivate(set) dynamic var unit: String = ""

    @objc fileprivate(set) dynamic var userAverage: Double = 0

    @objc fileprivate(set) dynamic var teamAverage: Double = 0

    @objc fileprivate(set) dynamic var dataAverage: Double = 0

    @objc fileprivate(set) dynamic var upperThreshold: Double = 0

    @objc fileprivate(set) dynamic var lowerThreshold: Double = 0

    @objc fileprivate(set) dynamic var maximum: Double = 0

    @objc fileprivate(set) dynamic var universe: Double = 0

    @objc fileprivate(set) dynamic var multiplier: Double = 0

    var dataPoints: List<DoubleObject> = List()

    var periods: List<StatisticsPeriod> = List()

    var chartType: ChartType = .activityLevel

    var title: String = ""
}

extension Statistics: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .dataPoint
    }

    func setData(_ data: StatisticsIntermediary, objectStore: ObjectStore) throws {
        key = data.key
        userAverage = data.userAverage
        teamAverage = data.teamAverage
        dataAverage = data.dataAverage
        upperThreshold = data.upperTreshold
        lowerThreshold = data.lowerTreshold
        maximum = data.maximum
        universe = 0.8//data.universe
        dataPoints.forEach { $0.delete() }
        periods.forEach { $0.delete() }
        dataPoints.append(objectsIn: data.dataPoints.map { DoubleObject(double: $0) })
        periods.append(objectsIn: data.periods.map { StatisticsPeriod( $0 ) })
        unit = data.unit
        multiplier = data.multiplier
    }
}

// MARK: - Displayable Values

extension Statistics {

    var userAverageDisplayableValue: String {
        return displayableValue(average: userAverage)
    }

    var teamAverageDisplayableValue: String {
        return displayableValue(average: teamAverage)
    }

    var dataAverageDisplayableValue: String {
        return displayableValue(average: dataAverage)
    }

    private func displayableValue(average: Double) -> String {
        if unit.isEmpty == true {
            return String(format: "%.1f", average.toFloat * multiplier.toFloat)
        }

        return String(format: "%.0f%@", average.toFloat * multiplier.toFloat, unit)
    }
}

// MARK: - Graph Values

extension Statistics {

    var userAngle: CGFloat {
        return angle(average: userAverageValue)
    }

    var dataAngle: CGFloat {
        return angle(average: dataAverageValue)
    }

    var teamAngle: CGFloat {
        return angle(average: teamAverageValue)
    }

    var userAverageValue: CGFloat {
        return averageValue(average: userAverage)
    }

    var teamAverageValue: CGFloat {
        return averageValue(average: teamAverage)
    }

    var dataAverageValue: CGFloat {
        return averageValue(average: dataAverage)
    }

    var pathColor: UIColor {
        if upperThreshold > lowerThreshold {
            return userAverage >= upperThreshold ? .cherryRed : userAverage < upperThreshold ? .white90 : .gray
        }

        return userAverage >= upperThreshold ? .white90 : userAverage < upperThreshold ? .cherryRed : .gray
    }

    var dataPointObjects: [DataPoint] {
        var dataPointObjects = [DataPoint]()

        dataPoints.forEach { (dataPoint: DoubleObject) in
            let dataValue = dataPoint.value.toFloat / (maximum.toFloat > 0 ? maximum.toFloat : 1)
            let dataPointObj: DataPoint = DataPoint(value: dataValue, color: dataPointColor(dataValue))
            dataPointObjects.append(dataPointObj)
        }

        return dataPointObjects
    }
}

// MARK: - Travel Periods

extension Statistics {

    // 1.   Get a list of single day Period
    // 2.   Create a list from type TravelTrip: (week: Int, day: Int, start: Int, end: Int, color: UIColor).
    // 3.   If start & end isSameDay == true ? start: period.startMinute, end: period.endMinute : 4.
    // 4.   If start & end isSameDay == false ? Get days between, iterate from start to end and create each day between.
    // 5.   Filter list for actual weekNumbers.

    var travelTrips: [TravelTrip] {
        switch chartType {
        case .travelTripsNextFourWeeks,
             .travelTripsAverageWeeks,
             .travelTripsTimeZoneChangedWeeks: return travelTripsFourWeeks
        case .travelTripsAverageYear,
             .travelTripsTimeZoneChangedYear: return travelTripsLastYear
        default: return []
        }
    }

    private var travelTripsLastYear: [TravelTrip] {
        let monthNumbers = chartType.labels.flatMap { Int($0) }
        var trips = [TravelTrip]()

        periods .forEach { (period: StatisticsPeriod) in
            if Calendar.sharedUTC.isDate(period.startDate, inSameDayAs: period.endDate) == true {
                let month = period.startDate.monthOfYear

                if monthNumbers.contains(month) == true {
                    let column = period.startDate.dayOfMonth
                    let row = monthNumbers.index(of: month) ?? 0
                    let trip = TravelTrip(column: column, row: row, start: period.startMinute, end: period.endMinute, color: period.status.color)
                    trips.append(trip)
                }
            } else {
                let daysBetween = period.startDate.days(to: period.endDate)

                for dayIndex in 0...daysBetween {
                    if let day = Calendar.sharedUTC.date(byAdding: .day, value: +dayIndex, to: period.startDate) {
                        let month = day.monthOfYear

                        if monthNumbers.contains(month) == true {
                            let column = day.dayOfMonth
                            let row = monthNumbers.index(of: month) ?? 0
                            let startMinute = dayIndex == 0 ? period.startMinute : 0
                            let endMinute = dayIndex == daysBetween ? period.endMinute : 1440
                            let trip = TravelTrip(column: column, row: row, start: startMinute, end: endMinute, color: period.status.color)
                            trips.append(trip)
                        }
                    }
                }
            }
        }

        return trips
    }

    private var travelTripsFourWeeks: [TravelTrip] {
        let weekNumbers = chartType.labels.flatMap { Int($0) }
        var trips = [TravelTrip]()

        periods.forEach { (period: StatisticsPeriod) in
            if Calendar.sharedUTC.isDate(period.startDate, inSameDayAs: period.endDate) == true {
                let week = period.startDate.weekOfYear

                if weekNumbers.contains(week) == true {
                    let column = period.startDate.dayOfWeek
                    let row = weekNumbers.index(of: week) ?? 0
                    let trip = TravelTrip(column: column, row: row, start: period.startMinute, end: period.endMinute, color: period.status.color)
                    trips.append(trip)
                }
            } else {
                let daysBetween = period.startDate.days(to: period.endDate)

                for dayIndex in 0...daysBetween {
                    if let day = Calendar.sharedUTC.date(byAdding: .day, value: +dayIndex, to: period.startDate) {
                        let week = day.weekOfYear

                        if weekNumbers.contains(week) == true {
                            let column = day.dayOfWeek
                            let row = weekNumbers.index(of: week) ?? 0
                            let startMinute = dayIndex == 0 ? period.startMinute : 0
                            let endMinute = dayIndex == daysBetween ? period.endMinute : 1440
                            let trip = TravelTrip(column: column, row: row, start: startMinute, end: endMinute, color: period.status.color)
                            trips.append(trip)
                        }
                    }
                }
            }
        }

        return trips
    }
}

// MARK: - Peak Performance

extension Statistics {

    var periodLastWeek: [[StatisticsPeriod]] {
        var lastWeek = [[StatisticsPeriod]]()

        for day in 0...6 {
            let previousDate = Calendar.sharedUTC.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            var sameDays = [StatisticsPeriod]()

            periods.forEach { (period: StatisticsPeriod) in
                if Calendar.sharedUTC.isDate(previousDate, inSameDayAs: period.startDate) == true {
                    sameDays.append(period)
                }
            }

            lastWeek.append(sameDays)
        }

        return lastWeek.reversed()
    }

    var periodNextWeek: [[StatisticsPeriod]] {
        var nextWeek = [[StatisticsPeriod]]()

        for day in 0...6 {
            let nextDate = Calendar.sharedUTC.date(byAdding: .day, value: +day, to: Date()) ?? Date()
            var sameDays = [StatisticsPeriod]()

            periods.forEach { (period: StatisticsPeriod) in
                if Calendar.sharedUTC.isDate(nextDate, inSameDayAs: period.startDate) == true {
                    sameDays.append(period)
                }
            }

            nextWeek.append(sameDays)
        }

        return nextWeek.reversed()
    }
}

// MARK: - Private

private extension Statistics {

    func dataPointColor(_ dataValue: CGFloat) -> UIColor {
        if upperThreshold > lowerThreshold {
            if dataValue > upperThreshold.toFloat {
                return .cherryRed
            } else if  dataValue <= lowerThreshold.toFloat {
                return .gray
            } else {
                return .white90
            }
        } else {
            if dataValue > upperThreshold.toFloat {
                return .white90
            } else if  dataValue < upperThreshold.toFloat {
                return .cherryRed
            } else {
                return .gray
            }
        }
    }

    private func tintColor(_ dataValue: CGFloat) -> UIColor {
        if upperThreshold > lowerThreshold {
            return dataValue >= upperThreshold.toFloat ? .cherryRed : dataValue <= lowerThreshold.toFloat ? .gray : .white90
        }

        return dataValue >= upperThreshold.toFloat ? .white90 : dataValue <= lowerThreshold.toFloat ? .cherryRed : .gray
    }

    func averageValue(average: Double) -> CGFloat {
        guard maximum > 0 else {
            return 0
        }

        return average.toFloat / maximum.toFloat
    }

    func angle(average: CGFloat) -> CGFloat {
        return (360 * average - 90).degreesToRadians
    }
}
