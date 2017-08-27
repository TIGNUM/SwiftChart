//
//  MyStatisticsDataActivity.swift
//  QOT
//
//  Created by Moucheg Mouradian on 20/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyStatisticsDataActivity: MyStatisticsData {

    // MARK: - Properties

    var displayType: DataDisplayType
    public private(set) var data: [EventGraphView.Column]

    // MARK: - Init

    init(teamAverage: CGFloat, dataAverage: CGFloat, userAverage: CGFloat, threshold: StatisticsThreshold<CGFloat>, data: [EventGraphData], fillColumn: Bool) {
        displayType = .all

        self.data = data.map { (columnData: EventGraphData) in
            var items: [EventGraphView.Item] = []
            let value = columnData.start - columnData.end
            let color: EventGraphView.Color = value >= threshold.upperThreshold ? .criticalColor : .lowColor

            if fillColumn == true && columnData.end > 0 {
                items.append(EventGraphView.Item(start: columnData.end, end: 0, color: .normalColor))
            }

            items.append(EventGraphView.Item(start: columnData.start, end: columnData.end, color: color))

            return EventGraphView.Column(items: items, width: 0.02)
        }
    }
}
