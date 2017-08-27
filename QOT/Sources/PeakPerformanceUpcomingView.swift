//
//  PeakPerformanceUpcomingView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class PeakPerformanceUpcomingView: UIView {

    // MARK: - Properties

    private var data: MyStatisticsDataPeriods

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Init

    init(frame: CGRect, data: MyStatisticsDataPeriods) {
        self.data = data

        super.init(frame: frame)

        setup()
    }

    private func setup() {
        let container = UIView()
        let labelContainer = UIView()

        addSubview(container)
        addSubview(labelContainer)

        container.topAnchor == self.topAnchor
        container.leadingAnchor == self.leadingAnchor
        container.trailingAnchor == self.trailingAnchor
        container.bottomAnchor == labelContainer.topAnchor

        labelContainer.leadingAnchor == self.leadingAnchor
        labelContainer.trailingAnchor == self.trailingAnchor
        labelContainer.bottomAnchor == self.bottomAnchor
        labelContainer.heightAnchor == 20

        layoutIfNeeded()

        let labels = generateLabels(type: data.displayType)
        labelContainer.drawLabelsForColumns(labels: labels, columnCount: labels.count, textColour: .white20, font: Font.H7Title, center: true)

        let performanceChart = PeakPerformanceUpcomingChartView(frame: container.bounds, data: data)
        container.addSubview(performanceChart)
    }

    private func generateLabels(type: DataDisplayType) -> [String] {
        let fmt = DateFormatter()
        let firstWeekday = Calendar.current.firstWeekday

        guard var labels = fmt.shortWeekdaySymbols else { return [] }
        labels = Array(labels[firstWeekday-1..<labels.count]) + labels[0..<firstWeekday-1]

        return labels
    }
}
