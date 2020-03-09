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
    var relatedLinksModel: [RelatedLinksModel]

    struct RelatedStrategiesModel {
        var title: String?
        var durationString: String?
        var contentId: Int?
        var contentItemId: Int?
        var section: ContentSection?
        var format: ContentFormat?
        var numberOfItems: Int?

        init() {}

        init(_ title: String?,
             _ durationString: String?,
             _ contentId: Int?,
             _ contentItemId: Int?,
             _ section: ContentSection?,
             _ format: ContentFormat?,
             _ numberOfItems: Int?) {
            self.title = title
            self.durationString = durationString
            self.contentId = contentId
            self.contentItemId = contentItemId
            self.section = section
            self.format = format
            self.numberOfItems = numberOfItems
        }
    }

    struct RelatedLinksModel {
        var description: String?
        var link: QDMAppLink?

        init() {}

        init(_ description: String?,
             _ link: QDMAppLink) {
            self.description = description
            self.link = link
        }
    }

    // MARK: - Init
    init(bucketTitle: String?,
         sprintTitle: String?,
         sprintInfo: String?,
         sprintStepNumber: Int?,
         relatedStrategiesModels: [RelatedStrategiesModel],
         relatedLinksModel: [RelatedLinksModel],
         domainModel: QDMDailyBriefBucket?,
         sprint: QDMSprint) {

        self.bucketTitle = bucketTitle
        self.sprintTitle = sprintTitle
        self.sprintInfo = sprintInfo
        self.sprint = sprint
        self.sprintStepNumber = sprintStepNumber
        self.relatedStrategiesModels = relatedStrategiesModels
        self.relatedLinksModel = relatedLinksModel
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? SprintChallengeViewModel else { return false }
        return super.isContentEqual(to: source) &&
            sprintStepNumber == source.sprintStepNumber &&
            domainModel?.sprint?.doneForToday == source.domainModel?.sprint?.doneForToday
    }
}
