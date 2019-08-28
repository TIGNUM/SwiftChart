//
//  BaseDailyBrief.swift
//  QOT
//
//  Created by Srikanth Roopa on 01.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import DifferenceKit
import qot_dal
class BaseDailyBriefViewModel: Differentiable {

    // MARK: - Properties
    typealias DifferenceIdentifier = String
    var domainModel: QDMDailyBriefBucket? = nil
    var subIdentifier = ""

    // MARK: - Init
    init(_ domainModel: QDMDailyBriefBucket?, _ subIdentifier: String? = "") {
        self.domainModel = domainModel
        self.subIdentifier = subIdentifier ?? ""
    }

    var differenceIdentifier: DifferenceIdentifier {
        return (self.domainModel?.bucketName ?? "") + subIdentifier
    }

    func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        return domainModel?.toBeVisionId == source.domainModel?.toBeVisionId &&
            domainModel?.toBeVisionTrackId == source.domainModel?.toBeVisionTrackId &&
            domainModel?.SHPIQuestionId == source.domainModel?.SHPIQuestionId &&
            domainModel?.latestGetToLevel5Value == source.domainModel?.latestGetToLevel5Value &&
            domainModel?.currentGetToLevel5Value == source.domainModel?.currentGetToLevel5Value &&
            domainModel?.stringValue == source.domainModel?.stringValue &&
            domainModel?.additionalDescription == source.domainModel?.additionalDescription &&
            domainModel?.contentCollectionIds == source.domainModel?.contentCollectionIds &&
            domainModel?.contentItemIds == source.domainModel?.contentItemIds &&
            domainModel?.questionGroupIds == source.domainModel?.questionGroupIds &&
            domainModel?.questionIds == source.domainModel?.questionIds &&
            domainModel?.answerIds == source.domainModel?.answerIds &&
            domainModel?.solveIds == source.domainModel?.solveIds &&
            domainModel?.preparationIds == source.domainModel?.preparationIds &&
            domainModel?.sprintId == source.domainModel?.sprintId &&
            domainModel?.dailyCheckInAnswerIds == source.domainModel?.dailyCheckInAnswerIds
    }
}
