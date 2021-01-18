//
//  MyQotAdminDCSixthQuestionSettingsWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminDCSixthQuestionSettingsWorker {

    var currentSetting: [Int] = DailyCheckinQuestionsPriorities.tbvShpiPeak
    var datasource: [[Int]] = [DailyCheckinQuestionsPriorities.tbvShpiPeak,
                               DailyCheckinQuestionsPriorities.tbvPeakShpi,
                               DailyCheckinQuestionsPriorities.shpiTbvPeak,
                               DailyCheckinQuestionsPriorities.shpiPeakTbv,
                               DailyCheckinQuestionsPriorities.peakTbvShpi,
                               DailyCheckinQuestionsPriorities.peakShpiTbv]

    // MARK: - Init
    init() { /* */ }
}
