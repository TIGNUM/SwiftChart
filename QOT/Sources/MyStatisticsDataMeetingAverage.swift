//
//  MyStatisticsDataMeetingAverage.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MyStatisticsDataMeetingAverage: MyStatisticsData {
    var displayType: DataDisplayType

    var teamMeetings: CGFloat
    var dataMeetings: CGFloat
    var userMeetings: CGFloat

    var teamDays: Int
    var dataDays: Int
    var userDays: Int

    var dayThreshold: StatisticsThreshold<CGFloat>
    var weekThreshold: StatisticsThreshold<CGFloat>

    // MARK: - Initialisation

    init(teamMeetings: CGFloat, dataMeetings: CGFloat, userMeetings: CGFloat, teamDays: Int, dataDays: Int, userDays: Int, dayThreshold: StatisticsThreshold<CGFloat>, weekThreshold: StatisticsThreshold<CGFloat>, displayType: DataDisplayType = .day) {
        self.displayType = displayType

        self.teamMeetings = teamMeetings
        self.dataMeetings = dataMeetings
        self.userMeetings = userMeetings

        self.teamDays = teamDays
        self.dataDays = dataDays
        self.userDays = userDays

        self.dayThreshold = dayThreshold
        self.weekThreshold = weekThreshold
    }

    // MARK: - Public methods

    func userAverage() -> CGFloat {
        return computeAverage(meetings: userMeetings, days: CGFloat(userDays))
    }

    func teamAverage() -> CGFloat {
        return computeAverage(meetings: teamMeetings, days: CGFloat(teamDays))
    }

    func dataAverage() -> CGFloat {
        return computeAverage(meetings: dataMeetings, days: CGFloat(dataDays))
    }

    func pathColor() -> DataDisplayColor {
        var threshold: StatisticsThreshold<CGFloat>
        switch displayType {
        case .day:
            threshold = dayThreshold
        case .week:
            threshold = weekThreshold
        default:
            return .inBetween
        }

        if threshold.upperThreshold <= userMeetings {
            return .above
        } else if userMeetings <= threshold.lowerThreshold {
            return .below
        }

        return .inBetween
    }

    // MARK: - Private methods

    private func computeAverage(meetings: CGFloat, days: CGFloat) -> CGFloat {
        switch displayType {
        case .day:
            return meetings / days
        case .week:
            let weekdays = days >= 7 ? 7.0 : days
            return meetings * weekdays / days
        default:
            return 0.0
        }
    }
}
