//
//  DailyBriefPeakPerformanceViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 02.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyPeakPerformanceCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var peakPerformanceSectionList = [MyPerformanceModelItem]()

    // MARK: - Init
    init(domainModel: QDMDailyBriefBucket?) {
        super.init(domainModel)
    }
}
