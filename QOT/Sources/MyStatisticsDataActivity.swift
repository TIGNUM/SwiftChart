//
//  MyStatisticsDataActivity.swift
//  QOT
//
//  Created by Moucheg Mouradian on 20/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

typealias EventGraphData = (start: CGFloat, end: CGFloat)

class MyStatisticsDataActivity: MyStatisticsData {

    var displayType: DataDisplayType
    public private(set) var teamAverage: CGFloat
    public private(set) var dataAverage: CGFloat
    public private(set) var userAverage: CGFloat
    private var threshold: StatisticsThreshold<CGFloat>
    public private(set) var data: [EventGraphView.Column]

    // MARK: - Initialisation

    init(teamAverage: CGFloat, dataAverage: CGFloat, userAverage: CGFloat, threshold: StatisticsThreshold<CGFloat>, data: [EventGraphData], fillColumn: Bool = false) {
        self.displayType = .all
        self.teamAverage = teamAverage
        self.dataAverage = dataAverage
        self.userAverage = userAverage
        self.threshold = threshold

        self.data = data.map { columnData in
            var items: [EventGraphView.Item] = []
            let value = columnData.start - columnData.end
            var color = EventGraphView.Color.normalColor

            if threshold.upperThreshold <= value {
                color = EventGraphView.Color.criticalColor
            } else if value <= threshold.lowerThreshold {
                color = EventGraphView.Color.lowColor
            }

            items.append(EventGraphView.Item(start: columnData.start, end: columnData.end, color: color))

            if fillColumn && columnData.end > 0 {
                items.append(EventGraphView.Item(start: columnData.end, end: 0, color: .normalColor))
            }

            return EventGraphView.Column(items: items, width: 0.02)
        }
    }
}
