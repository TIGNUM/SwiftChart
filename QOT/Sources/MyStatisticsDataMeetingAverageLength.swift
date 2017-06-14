//
//  MyStatisticsDataMeetingAverageLength.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

struct MyStatisticsDataMeetingAverageLength: MyStatisticsData {
    var displayType: DataDisplayType

    // Length in minutes
    var teamMeetingAverageLength: Int
    var dataMeetingAverageLength: Int
    var userMeetingAverageLength: Int

    var longestMeetingLength: Int

    var threshold: StatisticsThreshold<Int>

    // MARK: - Initialisation

    init(teamAverage: Int, dataAverage: Int, userAverage: Int, longest: Int, threshold: StatisticsThreshold<Int>) {
        displayType = .all

        teamMeetingAverageLength = teamAverage
        dataMeetingAverageLength = dataAverage
        userMeetingAverageLength = userAverage

        longestMeetingLength = longest

        self.threshold = threshold
    }

    // MARK: - Public methods

    func pathColor() -> DataDisplayColor {

        if threshold.upperThreshold <= userMeetingAverageLength {
            return .above
        } else if userMeetingAverageLength <= threshold.lowerThreshold {
            return .below
        }

        return .inBetween
    }
}
