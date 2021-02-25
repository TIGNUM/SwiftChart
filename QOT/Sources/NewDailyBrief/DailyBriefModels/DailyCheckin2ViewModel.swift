//
//  DailyCheckin2ViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 09.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DailyCheckin2ViewModel: BaseDailyBriefViewModel {

     // MARK: - Properties
    var type: DailyCheckIn2ModelItemType?
    var dailyCheckIn2TBVModel: DailyCheckIn2TBVModel?
    var dailyCheckIn2PeakPerformanceModel: DailyCheckIn2PeakPerformanceModel?
    var dailyCheck2SHPIModel: DailyCheck2SHPIModel?

    // MARK: - Init
    init(domainModel: QDMDailyBriefBucket?) {
        super.init(domainModel)
    }
}
