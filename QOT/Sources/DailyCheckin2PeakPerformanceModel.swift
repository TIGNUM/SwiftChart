//
//  DailyCheckinInsightsPeakPerformanceViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 02.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct DailyCheckIn2PeakPerformanceModel {
    // MARK: - Properties
    let title: String?
    let intro: String?
    let hasNoPerformance: Bool?

    // MARK: - Init
    init(title: String?, intro: String?, hasNoPerformance: Bool) {
        self.title = title
        self.intro = intro
        self.hasNoPerformance = hasNoPerformance
    }
}
