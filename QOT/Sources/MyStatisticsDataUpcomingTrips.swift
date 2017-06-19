//
//  MyStatisticsDataUpcomingTrips.swift
//  QOT
//
//  Created by Moucheg Mouradian on 15/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

// 1st dimension is weeks, second dimension is days, and days contain an Int representing the number of trips of that day
typealias UserUpcomingTrips = [[Int]]

class MyStatisticsDataUpcomingTrips: MyStatisticsData {

    var displayType: DataDisplayType

    public private(set) var teamAverage: CGFloat
    public private(set) var dataAverage: CGFloat
    public private(set) var userAverage: CGFloat
    public private(set) var userUpcomingTrips: UserUpcomingTrips
    public private(set) var labels: [String]

    // MARK: - Initialisation

    init(teamAverage: CGFloat, dataAverage: CGFloat, userAverage: CGFloat, userUpcomingTrips: UserUpcomingTrips, labels: [String]) {
        self.displayType = .all

        self.teamAverage = teamAverage
        self.dataAverage = dataAverage
        self.userAverage = userAverage
        self.userUpcomingTrips = userUpcomingTrips
        self.labels = labels
    }

    // MARK: - Public methods

    func pathColor() -> DataDisplayColor {
        return .below
    }
}
