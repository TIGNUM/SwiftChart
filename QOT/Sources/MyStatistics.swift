//
//  MyStatistics.swift
//  QOT
//
//  Created by karmic on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class MyStatistics: SyncableObject {

    fileprivate(set) dynamic var key: String = ""

    fileprivate(set) dynamic var unit: String = ""

    fileprivate(set) dynamic var userAverage: Double = 0

    fileprivate(set) dynamic var teamAverage: Double = 0

    fileprivate(set) dynamic var dataAverage: Double = 0

    fileprivate(set) dynamic var upperThreshold: Double = 0

    fileprivate(set) dynamic var lowerThreshold: Double = 0

    fileprivate(set) dynamic var maximum: Double = 0

    fileprivate(set) dynamic var universe: Double = 0

    fileprivate(set) dynamic var multiplier: Double = 0

    var dataPoints: List<DoubleObject> = List()

    var periods: List<MyStatisticsPeriod> = List()
}

extension MyStatistics: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .dataPoint
    }

    func setData(_ data: MyStatisticsIntermediary, objectStore: ObjectStore) throws {
        key = data.key
        userAverage = data.userAverage
        teamAverage = data.teamAverage
        dataAverage = data.dataAverage
        upperThreshold = data.upperTreshold
        lowerThreshold = data.lowerTreshold
        maximum = data.maximum
        universe = data.universe
        dataPoints.forEach { $0.delete() }
        periods.forEach { $0.delete() }
        dataPoints.append(objectsIn: data.dataPoints.map { DoubleObject(double: $0) })
        periods.append(objectsIn: data.periods.map { MyStatisticsPeriod( $0 ) })
        unit = data.unit
        multiplier = data.multiplier
    }
}

// MARK: - Displayable Values

extension MyStatistics {

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

extension MyStatistics {

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
        return userAverage >= upperThreshold ? .cherryRed : userAverage <= lowerThreshold ? .white90 : .gray
    }

    var dataPointObjects: [DataPoint] {
        var dataPointObjects = [DataPoint]()

        dataPoints.forEach { (dataPoint: DoubleObject) in
            let color: UIColor = dataPoint.value >= upperThreshold ? .cherryRed : dataPoint.value <= lowerThreshold ? .white90 : .gray
            let dataPointObj: DataPoint = DataPoint(value: dataPoint.value.toFloat, color: color)
            dataPointObjects.append(dataPointObj)
        }

        return dataPointObjects
    }

    var userUpcomingTrips: UserUpcomingTrips {
        var trips = UserUpcomingTrips()

        periods.forEach { (period: MyStatisticsPeriod) in
            for day in 0..<28 {
                if Range<Date>.makeOneDay(daysFromNow: day).overlaps(period.range) {
                    trips[day] = UpcomingTrip(count: (trips[day]?.count ?? 0) + 1, status: period.status)
                }
            }
        }

        return trips
    }
}

// MARK: - Private

private extension MyStatistics {

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
