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
    var howYouFeelToday: String?
    var asteriskText: String?
    var title: String?
    var dailyCheckImageView: URL?
    var readinessScore: Int?
    var impactDataModels: [ImpactDataViewModel]?

    struct ImpactDataViewModel {
        var title: String?
        var subTitle: String?
        var averageValue: Double?
        var targetRefValue: String?
    }

    // MARK: - Init
    internal init(title: String?, dailyCheckImageView: URL?, howYouFeelToday: String?, asteriskText: String?, readinessScore: Int?, impactDataModels: [ImpactDataViewModel]?, readinessIntro: String?, domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.dailyCheckImageView = dailyCheckImageView
        self.howYouFeelToday = howYouFeelToday
        self.asteriskText = asteriskText
        self.readinessScore = readinessScore
        self.impactDataModels = impactDataModels
        self.readinessIntro = readinessIntro
        super.init(domainModel)
    }
}
