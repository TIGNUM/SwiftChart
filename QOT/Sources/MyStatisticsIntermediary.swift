//
//  MyStatisticsIntermediary.swift
//  QOT
//
//  Created by karmic on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct MyStatisticsIntermediary: DownSyncIntermediary {

    let key: String
    let userAverage: Double
    let teamAverage: Double
    let dataAverage: Double
    let upperTreshold: Double
    let lowerTreshold: Double
    let maximum: Double
    let dataPoints: [Double]
    let periods: [MyStatisticsPeriodIntermediary]

    init(json: JSON) throws {
        key = try json .getItemValue(at: .key, fallback: "")
        userAverage = try json .getItemValue(at: .userAverage, fallback: 0)
        teamAverage = try json .getItemValue(at: .teamAverage, fallback: 0)
        dataAverage = try json .getItemValue(at: .dataAverage, fallback: 0)
        upperTreshold = try json .getItemValue(at: .upperThreshold, fallback: 0)
        lowerTreshold = try json .getItemValue(at: .lowerThreshold, fallback: 0)
        maximum = try json .getItemValue(at: .maximum, fallback: 0)
        dataPoints = try json.getArray(at: .dataPoints, fallback: [])
        periods = try json.getArray(at: .periods, fallback: [])
    }
}
