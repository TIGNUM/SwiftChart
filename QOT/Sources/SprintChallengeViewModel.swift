//
//  SprintChallengeViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SprintChallengeViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var bucketTitle: String?
    var sprintTitle: String?
    var sprintInfo: String?
    var sprintStepNumber: Int?
    var sprint: QDMSprint
    var relatedStrategiesModels: [RelatedStrategiesModel]

    struct RelatedStrategiesModel {
        var title: String?
        var durationString: String?
        var remoteID: Int?
        var section: ContentSection?
        var format: ContentFormat?
        var numberOfItems: Int?

        init() {}

        init(_ title: String?, _ durationString: String?, _ remoteID: Int?, _ section: ContentSection?, _ format: ContentFormat?, _ numberOfItems: Int?) {
            self.title = title
            self.durationString = durationString
            self.remoteID = remoteID
            self.section = section
            self.format = format
            self.numberOfItems = numberOfItems
        }
    }

    // MARK: - Init
    init(bucketTitle: String?,
         sprintTitle: String?,
         sprintInfo: String?,
         sprintStepNumber: Int?,
         relatedStrategiesModels: [RelatedStrategiesModel],
         domainModel: QDMDailyBriefBucket?,
         sprint: QDMSprint) {

        self.bucketTitle = bucketTitle
        self.sprintTitle = sprintTitle
        self.sprintInfo = sprintInfo
        self.sprint = sprint
        self.sprintStepNumber = sprintStepNumber
        self.relatedStrategiesModels = relatedStrategiesModels
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? SprintChallengeViewModel else { return false }
        return super.isContentEqual(to: source) &&
            sprintStepNumber == source.sprintStepNumber &&
            domainModel?.sprint?.doneForToday == source.domainModel?.sprint?.doneForToday
    }
}
