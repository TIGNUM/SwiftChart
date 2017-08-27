//
//  MyStatisticsDataPeriods.swift
//  QOT
//
//  Created by Moucheg Mouradian on 16/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyStatisticsDataPeriods: MyStatisticsData {

    // MARK: - Properties

    var displayType: DataDisplayType
    private var teamData: [Int: CGFloat]
    private var dataData: [Int: CGFloat]
    private var userData: [Int: CGFloat]
    private var statsPeriods: [Int: ChartDimensions]
    // Array of Period s for each column
    public private(set) var periods: [Period]

    private var thresholds: [Int: StatisticsThreshold<TimeInterval>]

    // MARK: - Initialisation

    init(teamData: [Int: CGFloat],
         dataData: [Int: CGFloat],
         userData: [Int: CGFloat],
         periods: [Period],
         statsPeriods: [Int: ChartDimensions],
         thresholds: [Int: StatisticsThreshold<TimeInterval>],
         displayType: DataDisplayType = .weeks) {
            self.displayType = displayType
            self.teamData = teamData
            self.dataData = dataData
            self.userData = userData
            self.statsPeriods = statsPeriods
            self.periods = periods
            self.thresholds = thresholds
    }

    // MARK: - Public methods

    func userAverage() -> CGFloat {
        guard let value = userData[displayType.id] else {
            return 0
        }

        return value
    }

    func teamAverage() -> CGFloat {
        guard let value = teamData[displayType.id] else {
            return 0
        }

        return value
    }

    func dataAverage() -> CGFloat {
        guard let value = dataData[displayType.id] else {
            return 0
        }

        return value
    }

    func statsPeriod() -> ChartDimensions {
        guard let value = statsPeriods[displayType.id] else {
            return ChartDimensions(columns: 1, rows: 1, length: 1)
        }

        return value
    }

    func threshold() -> StatisticsThreshold<TimeInterval> {
        guard let value = thresholds[displayType.id] else {
            return StatisticsThreshold(upperThreshold: 0, lowerThreshold: 0)
        }

        return value
    }

    func pathColor(forPeriod period: Period) -> DataDisplayColor {
        guard let limits = thresholds[displayType.id] else {
            return .inBetween
        }

        if limits.upperThreshold <= period.duration {
            return .above
        } else if period.duration <= limits.lowerThreshold {
            return .below
        }
        
        return .inBetween
    }
}
