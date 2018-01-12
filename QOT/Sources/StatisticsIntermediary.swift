//
//  StatisticsIntermediary.swift
//  QOT
//
//  Created by karmic on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct StatisticsIntermediary: DownSyncIntermediary {

    struct Threshold: JSONDecodable {
        let colorState: String
        let min: Double?
        let max: Double?

        init(json: JSON) throws {
            colorState = try json .getItemValue(at: .colorState, fallback: "NORMAL")
            min = try json .getItemValue(at: .min)
            max = try json .getItemValue(at: .max)
        }
    }

    let key: String
    let userAverage: Double
    let teamAverage: Double
    let dataAverage: Double
    let upperTreshold: Double
    let lowerTreshold: Double
    let maximum: Double
    let universe: Double
    let dataPoints: [Double]
    let periods: [StatisticsPeriodIntermediary]
    let unit: String
    let multiplier: Double
    let thresholds: [Threshold]
    let maxValueOf: String
    let decimalPlaces: Int

    init(json: JSON) throws {
        key = try json .getItemValue(at: .key, fallback: "")
        userAverage = try json .getItemValue(at: .userAverage, fallback: 0)
        teamAverage = try json .getItemValue(at: .teamAverage, fallback: 0)
        dataAverage = try json .getItemValue(at: .dataAverage, fallback: 0)
        upperTreshold = try json .getItemValue(at: .upperThreshold, fallback: 0)
        lowerTreshold = try json .getItemValue(at: .lowerThreshold, fallback: 0)
        maximum = try json .getItemValue(at: .maximum, fallback: 0)
        universe = try json .getItemValue(at: .universe, fallback: 0)
        dataPoints = try json.getArray(at: .dataPoints, fallback: [])
        periods = try json.getArray(at: .periods, fallback: [])
        unit = try json.getItemValue(at: .unit, fallback: "")
        multiplier = try json.getItemValue(at: .multiplier, fallback: 1)
        thresholds = try json.getArray(at: .thresholds, fallback: [])
        maxValueOf = try json .getItemValue(at: .maxValueOf, fallback: "")
        decimalPlaces = try json .getItemValue(at: .decimalPlaces, fallback: 0)
    }
}
