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
    var feedback: String?
    var feedbackRelatedLink: QDMAppLink?
    var linkCTA: String?
    var dailyCheckImageURL: URL?
    var readinessScore: Int?
    var isExpanded: Bool
    var enableButton: Bool
    var type = ImpactReadinessType.NO_CHECK_IN

    // MARK: - Init
    internal init(title: String?,
                  feedback: String?,
                  feedbackRelatedLink: QDMAppLink?,
                  linkCTA: String?,
                  dailyCheckImageURL: URL?,
                  readinessScore: Int?,
                  readinessIntro: String?,
                  isExpanded: Bool,
                  enableButton: Bool,
                  domainModel: QDMDailyBriefBucket?) {
        self.title = title
        self.feedback = feedback
        self.feedbackRelatedLink = feedbackRelatedLink
        self.linkCTA = linkCTA
        self.dailyCheckImageURL = dailyCheckImageURL
        self.readinessScore = readinessScore
        self.readinessIntro = readinessIntro
        self.isExpanded = isExpanded
        self.enableButton = enableButton
        super.init(domainModel)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? ImpactReadinessCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            readinessScore == source.readinessScore &&
            enableButton == source.enableButton &&
            domainModel?.toBeVision?.profileImageResource?.url() == source.domainModel?.toBeVision?.profileImageResource?.url() &&
            domainModel?.dailyCheckInResult?.targetSleepQuantity == source.domainModel?.dailyCheckInResult?.targetSleepQuantity
    }
}
