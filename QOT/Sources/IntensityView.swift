//
//  IntensityView.swift
//  QOT
//
//  Created by karmic on 24.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class IntensityView: UIView {

    // MARK: - Properties

    fileprivate let myStatistics: MyStatistics
    fileprivate let data: MyStatisticsDataPeriods

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics, data: MyStatisticsDataPeriods) {
        self.myStatistics = myStatistics
        self.data = data

        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension IntensityView {

    func setup() {
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
        labelContainer.drawLabelsForColumns(labels: labels,
                                            columnCount: labels.count,
                                            textColour: .white20,
                                            font: Font.H7Title,
                                            center: true)
        let intensityChart = IntensityChartView(frame: container.bounds, myStatistics: myStatistics)
        container.addSubview(intensityChart)
    }

    func generateLabels(type: DataDisplayType) -> [String] {
        switch type {
        case .week: return veryShortWeekdaySymbols()
        case .month: return weekNumbers()
        default: return []
        }
    }

    private func weekNumbers() -> [String] {
        let currentWeekNumber = Calendar.current.component(.weekOfYear, from: Date())

        return []
    }

    private func veryShortWeekdaySymbols() -> [String] {
        let formatter = DateFormatter()
        let currentWeekday = Calendar.current.component(.weekday, from: Date())

        guard var labels = formatter.veryShortWeekdaySymbols else {
            return []
        }

        labels = Array(labels[currentWeekday-1 ..< labels.count]) + labels[0 ..< currentWeekday-1]

        return labels.reversed()
    }
}
