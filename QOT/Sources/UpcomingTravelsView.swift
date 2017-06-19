//
//  UpcomingTravelsView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 15/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class UpcomingTravelsView: UIView {
    private var data: MyStatisticsDataUpcomingTrips

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, data: MyStatisticsDataUpcomingTrips) {
        self.data = data

        super.init(frame: frame)

        setup()
    }

    private func setup() {

        let padding: CGFloat = 8.0
        let separatorHeight: CGFloat = 1.0

        let container = UIView()
        let labelContainer = UIView()

        addSubview(container)
        addSubview(labelContainer)

        container.topAnchor == self.topAnchor + padding * 2 + separatorHeight
        container.leadingAnchor == self.leadingAnchor + padding
        container.trailingAnchor == self.trailingAnchor - padding
        container.bottomAnchor == labelContainer.topAnchor

        labelContainer.leadingAnchor == self.leadingAnchor + padding
        labelContainer.trailingAnchor == self.trailingAnchor - padding
        labelContainer.bottomAnchor == self.bottomAnchor
        labelContainer.heightAnchor == 20

        layoutIfNeeded()

        let labels = data.labels

        labelContainer.drawLabelsForColumns(labels: labels, columnCount: labels.count, textColour: .white20, font: UIFont(name: "BentonSans-Book", size: 11)!)

        let travelChart = UpcomingTravelsChartView(frame: container.bounds, data: data.userUpcomingTrips)
        container.addSubview(travelChart)
    }
}
