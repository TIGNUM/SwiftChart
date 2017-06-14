//
//  AverageMeetingLengthView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class AverageMeetingLengthView: UIView {

    private var data: MyStatisticsDataMeetingAverageLength

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, data: MyStatisticsDataMeetingAverageLength) {
        self.data = data

        super.init(frame: frame)

        setup()
    }

    private func setup() {
        let userValue = CGFloat(data.userMeetingAverageLength) / CGFloat(data.longestMeetingLength)
        let teamValue = CGFloat(data.teamMeetingAverageLength) / CGFloat(data.longestMeetingLength)
        let dataValue = CGFloat(data.dataMeetingAverageLength) / CGFloat(data.longestMeetingLength)

        let padding: CGFloat = 8.0
        let separatorHeight: CGFloat = 1.0

        let progressWheel = AverageMeetingLengthProgressWheel(frame: self.bounds,
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
