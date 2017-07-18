//
//  MyStatisticsDataAverage.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol Digits {
    static func <= (lhs: Self, rhs: Self) -> Bool
}

extension Int: Digits {}
extension Float: Digits {}
extension CGFloat: Digits {}
extension Double: Digits {}

struct MyStatisticsDataAverage<T: Digits>: MyStatisticsData {

    var displayType: DataDisplayType
    var teamAverage: T
    var dataAverage: T
    var userAverage: T
    var maximum: T
    var threshold: StatisticsThreshold<T>

    // MARK: - Initialisation

    init(teamAverage: T, dataAverage: T, userAverage: T, maximum: T, threshold: StatisticsThreshold<T>, displayType: DataDisplayType = .all) {
        self.displayType = displayType
        self.teamAverage = teamAverage
        self.dataAverage = dataAverage
        self.userAverage = userAverage
        self.maximum = maximum
        self.threshold = threshold
    }

    // MARK: - Public methods

    func pathColor() -> DataDisplayColor {
        if threshold.upperThreshold <= userAverage {
            return .above
        } else if userAverage <= threshold.lowerThreshold {
            return .below
        }

        return .inBetween
    }
}
