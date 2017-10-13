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

typealias Period = (start: Date, duration: TimeInterval, minutes: Int)

typealias ChartDimensions = (columns: Int, rows: Int, length: Int)

typealias StatisticsThreshold<T> = (upperThreshold: T, lowerThreshold: T)

typealias TravelTrip = (row: Int, column: Int, start: Int, end: Int, color: UIColor)

typealias LastFourWeeks = (day: Date, weekNumber: Int, dayNumber: Int)

typealias DataPoint = (value: CGFloat, color: UIColor)
