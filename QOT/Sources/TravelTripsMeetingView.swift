//
//  TravelTripsMeetingView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 16/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class TravelTripsMeetingView: UIView {
    private var data: MyStatisticsDataTravelPeriods

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, data: MyStatisticsDataTravelPeriods) {
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
        labelContainer.drawLabelsForColumns(labels: labels, columnCount: labels.count, textColour: .white20, font: UIFont(name: "BentonSans-Book", size: 11)!)

        let travelChart = TravelTripsMeetingChartView(frame: container.bounds, data: data)
        container.addSubview(travelChart)
    }

    private func generateLabels(type: DataDisplayType) -> [String] {
        let now = Date()

        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.month, .weekOfYear])

        var labels: [String] = []
        switch type {
        case .weeks:
            let days = 7
            let upperBound = 3
            for i in 0...upperBound {
                breakLabel:
                if let date = calendar.date(byAdding: .day, value: (i - upperBound) * days, to: now) {
                    let components = calendar.dateComponents(unitFlags, from: date as Date)
                    guard let weekOfYear = components.weekOfYear else {
                        labels.append("")
                        break breakLabel
                    }
                    labels.append("\(weekOfYear)")
                }
            }
        case .year:
            let months = 1
            let upperBound = 11
            for i in 0...upperBound {
                breakLabel:
                if let date = calendar.date(byAdding: .month, value: (i - upperBound) * months, to: now) {
                    let components = calendar.dateComponents(unitFlags, from: date as Date)
                    guard let monthOfYear = components.month else {
                        labels.append("")
                        break breakLabel
                    }
                    labels.append("\(monthOfYear)")
                }
            }
        default:
            break
        }
        return labels
    }

}
