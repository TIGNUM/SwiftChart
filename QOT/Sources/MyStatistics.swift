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
        dataPoints.forEach { $0.delete() }
        periods.forEach { $0.delete() }
        dataPoints.append(objectsIn: data.dataPoints.map({ DoubleObject(double: $0) }))
        periods.append(objectsIn: data.periods.map({ MyStatisticsPeriod( $0 ) }))
        unit = data.unit
        multiplier = data.multiplier
    } 
}
