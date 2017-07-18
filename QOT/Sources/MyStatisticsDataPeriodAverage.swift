//
//  MyStatisticsDataPeriodAverage.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MyStatisticsDataPeriodAverage: MyStatisticsData {
    var displayType: DataDisplayType

    private var teamData: [Int: CGFloat]
    private var dataData: [Int: CGFloat]
    private var userData: [Int: CGFloat]

    // This Will represent 100% value on the chart
    private var maxData: [Int: CGFloat]

    private var thresholds: [Int: StatisticsThreshold<CGFloat>]

    // MARK: - Initialisation

    init(teamData: [Int: CGFloat], dataData: [Int: CGFloat], userData: [Int: CGFloat], maxData: [Int: CGFloat], thresholds: [Int: StatisticsThreshold<CGFloat>], displayType: DataDisplayType = .week) {
        self.displayType = displayType

        self.teamData = teamData
        self.dataData = dataData
        self.userData = userData

        self.maxData = maxData

        self.thresholds = thresholds
    }

    // MARK: - Public methods

    func userAverage() -> CGFloat {
        guard let value = userData[displayType.id] else { return 0 }
        return value
    }

    func teamAverage() -> CGFloat {
        guard let value = teamData[displayType.id] else { return 0 }
        return value
    }

    func dataAverage() -> CGFloat {
        guard let value = dataData[displayType.id] else { return 0 }
        return value
    }

    func threshold() -> StatisticsThreshold<CGFloat> {
        guard let value = thresholds[displayType.id] else { return StatisticsThreshold(upperThreshold: 0, lowerThreshold: 0) }

        return value
    }

    func maxValue() -> CGFloat {
        guard let value = maxData[displayType.id] else { return 0 }
        return value
    }

    func pathColor() -> DataDisplayColor {
        guard let limits = thresholds[displayType.id] else { return .inBetween }
        let average = userAverage()
        let max = maxValue()

        if limits.upperThreshold * max <= average {
            return .above
        } else if average <= limits.lowerThreshold * max {
            return .below
        }

        return .inBetween
    }
}
