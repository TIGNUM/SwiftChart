//
//  SprintChallengeViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import qot_dal
import Foundation

final class SprintChallengeViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var bucketTitle: String?
    var sprintTitle: String?
    var sprintInfo: String?
    var sprintStepNumber: Int?
    var relatedStrategiesModels: [RelatedStrategiesModel]

    struct RelatedStrategiesModel {
        var title: String?
        var durationString: String?
        var remoteID: Int?
    }

    // MARK: - Init
    init(bucketTitle: String?, sprintTitle: String?, sprintInfo: String?, sprintStepNumber: Int?, relatedStrategiesModels: [RelatedStrategiesModel], domainModel: QDMDailyBriefBucket?) {
        self.bucketTitle = bucketTitle
        self.sprintTitle = sprintTitle
        self.sprintInfo = sprintInfo
        self.sprintStepNumber = sprintStepNumber
        self.relatedStrategiesModels = relatedStrategiesModels
        super.init(domainModel)
    }
}
