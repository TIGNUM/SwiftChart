//
//  TravelMaxTimeZoneChangesView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class TravelMaxTimeZoneChangesView: UIView {

    // MARK: - Properties

    fileprivate var data: MyStatisticsDataAverage<Int>

    // MARK: - Init

    init(frame: CGRect, data: MyStatisticsDataAverage<Int>) {
        self.data = data
        
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TravelMaxTimeZoneChangesView {

    func setup() {
        let userValue = CGFloat(data.userAverage) / CGFloat(data.maximum)
        let teamValue = CGFloat(data.teamAverage) / CGFloat(data.maximum)
        let dataValue = CGFloat(data.dataAverage) / CGFloat(data.maximum)
        let padding: CGFloat = 8.0
        let separatorHeight: CGFloat = 1.0
        let progressWheel = TravelMaxTimeZoneChangesProgressWheel(frame: self.bounds,
                                                                  value: userValue,
                                                                  teamValue: teamValue,
                                                                  dataValue: dataValue,
                                                                  pathColor: data.pathColor().color)
        addSubview(progressWheel)
        progressWheel.topAnchor == self.topAnchor + (2 * padding + separatorHeight)
        progressWheel.bottomAnchor == self.bottomAnchor - padding
        progressWheel.leftAnchor == self.leftAnchor
        progressWheel.rightAnchor == self.rightAnchor
    }
}
