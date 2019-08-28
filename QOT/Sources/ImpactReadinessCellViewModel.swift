//
//  ImpactReadinessCellViewModel.swift
//  QOT
//
//  Created by Srikanth Roopa on 15.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ImpactReadinessCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var readinessIntro: String?
    var title: String?
    var dailyCheckImageView: URL?
    var readinessScore: Int?
    var type = ImpactReadinessType.NO_CHECK_IN

    // MARK: - Init
    internal init(title: String?,
                  dailyCheckImageView: URL?,
                  readinessScore: Int?,
                  readinessIntro: String?,
                  domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.dailyCheckImageView = dailyCheckImageView
        self.readinessScore = readinessScore
        self.readinessIntro = readinessIntro
        super.init(domainModel)
    }
}
