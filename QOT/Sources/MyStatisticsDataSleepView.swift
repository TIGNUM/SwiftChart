//
//  SleepChartViewData.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/20/17.
//  Copyright © 2017 Tignum. All rights reserved.
//
import UIKit
import Foundation

final class MyStatisticsDataSleepView: MyStatisticsData {
    var displayType: DataDisplayType

    public private(set) var data: [CGFloat]
    public private(set) var threshold: CGFloat
    public private(set) var dataAverage: CGFloat
    public private(set) var userAverage: CGFloat
    public private(set) var teamAverage: CGFloat
    public private(set) var chartType: ChartType

    enum ChartType {
        case qualitySleep
        case quantitySleep

        func lineColor(value: CGFloat, average: CGFloat) -> UIColor {
            return value <= average ? .cherryRed : .white
        }

        var borderColor: UIColor {
            return .white20
        }

        var sides: Int {
            return 5
        }

        var borderWidth: CGFloat {
            return 1
        }

        var days: [String] {
            let formatter = DateFormatter()
            let day = formatter.veryShortStandaloneWeekdaySymbols
            let temDay = day?.first

            guard var days = day, let temp = temDay else {
                preconditionFailure("day empty")
            }
            days.removeFirst()
            days.append(temp)
            return days
        }
    }

    init (chart: ChartType, teamAverage: CGFloat, dataAverage: CGFloat, userAverage: CGFloat, data: [CGFloat]) {
        self.displayType = DataDisplayType.all
        self.teamAverage = teamAverage
        self.dataAverage = dataAverage
        self.userAverage = userAverage
        self.data = data
        self.threshold = userAverage
        self.chartType = chart
    }
}
