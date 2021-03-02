//
//  SprintChallengeViewModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SprintsCollectionViewModel: BaseDailyBriefViewModel {
    var items: [SprintChallengeViewModel]?

    init(items: [SprintChallengeViewModel], domainModel: QDMDailyBriefBucket) {
        super.init(domainModel)
        self.items = items
    }
}

final class SprintChallengeViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var bucketTitle: String?
    var sprintTitle: String?
    var sprintInfo: String?
    var sprintStepNumber: Int?
    var sprint: QDMSprint
    var dayTask: String?
    var relatedStrategiesModels: [RelatedItemsModel]

    struct RelatedItemsModel {
        var title: String?
        var durationString: String?
        var contentId: Int?
        var contentItemId: Int?
        var section: ContentSection?
        var format: ContentFormat?
        var numberOfItems: Int?
        var link: QDMAppLink?
        var videoThumbnailImageUrl: String?
        var videoUrl: String?
        var sprintDay: String?

        init() {}

        init(_ title: String?,
             _ durationString: String?,
             _ contentId: Int?,
             _ contentItemId: Int?,
             _ section: ContentSection?,
             _ format: ContentFormat?,
             _ numberOfItems: Int?,
             _ link: QDMAppLink?,
             _ videoThumbnailImageUrl: String? = nil,
             _ videoUrl: String? = nil,
             _ sprintDay: String?) {
            self.title = title
            self.durationString = durationString
            self.contentId = contentId
            self.contentItemId = contentItemId
            self.section = section
            self.format = format
            self.numberOfItems = numberOfItems
            self.link = link
            self.videoThumbnailImageUrl = videoThumbnailImageUrl
            self.videoUrl = videoUrl
            self.sprintDay = sprintDay
        }
    }

    // MARK: - Init
    init(bucketTitle: String?,
         sprintTitle: String?,
         sprintInfo: String?,
         image: String?,
         sprintStepNumber: Int?,
         relatedStrategiesModels: [RelatedItemsModel],
         domainModel: QDMDailyBriefBucket?,
         sprint: QDMSprint,
         dayTask: String?) {

        self.bucketTitle = bucketTitle
        self.sprintTitle = sprintTitle
        self.sprintInfo = sprintInfo
        self.sprint = sprint
        self.sprintStepNumber = sprintStepNumber
        self.dayTask = dayTask
        self.relatedStrategiesModels = relatedStrategiesModels.filter { $0.sprintDay == "SPRINT_BUCKET_DAY_" + "\(sprintStepNumber ?? .zero)" }
        let caption = sprintTitle

        super.init(domainModel,
                   caption: caption,
                   title: dayTask,
                   body: sprintInfo,
                   image: image)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? SprintChallengeViewModel else { return false }
        return super.isContentEqual(to: source) &&
            sprintStepNumber == source.sprintStepNumber &&
            domainModel?.sprint?.doneForToday == source.domainModel?.sprint?.doneForToday
    }
}
