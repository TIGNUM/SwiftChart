//
//  MyQotAdminDCSixthQuestionSettingsWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminDCSixthQuestionSettingsWorker {

    var currentSetting: [Int] = dailyCheckinQuestionsPriorities.tbvShpiPeak
    var datasource: [[Int]] = [dailyCheckinQuestionsPriorities.tbvShpiPeak,
                               dailyCheckinQuestionsPriorities.tbvPeakShpi,
                               dailyCheckinQuestionsPriorities.shpiTbvPeak,
                               dailyCheckinQuestionsPriorities.shpiPeakTbv,
                               dailyCheckinQuestionsPriorities.peakTbvShpi,
                               dailyCheckinQuestionsPriorities.peakShpiTbv]

    // MARK: - Init
    init() { /**/ }
}
