//
//  ToBeVisionReport.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class ToBeVisionReport {
    let title: String
    let subtitle: String
    var selectedDate: Date
    let report: QDMToBeVisionRatingReport

    init(title: String,
         subtitle: String,
         selectedDate: Date,
         report: QDMToBeVisionRatingReport) {
        self.title = title
        self.subtitle = subtitle
        self.selectedDate = selectedDate
        self.report = report
    }
}
