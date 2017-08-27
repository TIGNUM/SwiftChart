//
//  Typealiases.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Type Alias

typealias Index = Int

typealias Period = (start: Date, duration: TimeInterval)

typealias ChartDimensions = (columns: Int, rows: Int, length: Int)

typealias StatisticsThreshold<T> = (upperThreshold: T, lowerThreshold: T)

typealias EventGraphData = (start: CGFloat, end: CGFloat)

typealias UpcomingTrip = (count: Int, status: MyStatisticsPeriod.Status)

typealias UserUpcomingTrips = [Int: UpcomingTrip]
