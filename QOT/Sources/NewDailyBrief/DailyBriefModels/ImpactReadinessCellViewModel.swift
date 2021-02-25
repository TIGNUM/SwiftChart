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
    var feedback: String?
    var feedbackRelatedLink: QDMAppLink?
    var linkCTA: String?
    var dailyCheckImageURL: URL?
    var readinessScore: Int?
    var isCalculating: Bool
    var hasError: Bool
    var type = ImpactReadinessType.NO_CHECK_IN

    // MARK: - Init
    internal init(title: String?,
                  feedback: String?,
                  feedbackRelatedLink: QDMAppLink?,
                  image: String?,
                  linkCTA: String?,
                  dailyCheckImageURL: URL?,
                  readinessScore: Int?,
                  readinessIntro: String?,
                  isCalculating: Bool,
                  hasError: Bool,
                  domainModel: QDMDailyBriefBucket?) {
        self.feedback = feedback
        self.feedbackRelatedLink = feedbackRelatedLink
        self.linkCTA = linkCTA
        self.dailyCheckImageURL = dailyCheckImageURL
        self.readinessScore = readinessScore
        self.readinessIntro = readinessIntro
        self.isCalculating = isCalculating
        self.hasError = hasError
        let calculateTitle = AppTextService.get(.daily_brief_section_impact_readiness_calculate_title)
        let completedTitle = AppTextService.get(.daily_brief_section_impact_readiness_completed_title)
        let caption = feedback?.isEmpty == true ? calculateTitle : completedTitle
        let body = feedback?.isEmpty ?? true ? readinessIntro : feedback
        super.init(domainModel, caption: caption, title: caption, body: body, image: image)
        self.attributedTitle = ImpactReadinessCellViewModel.createAttributedImpactReadinessTitle(for: self.readinessScore,
                                                                                                 impactReadinessNoDataTitle: title)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? ImpactReadinessCellViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            readinessScore == source.readinessScore &&
            hasError == source.hasError &&
            domainModel?.toBeVision?.profileImageResource?.url() == source.domainModel?.toBeVision?.profileImageResource?.url() &&
            domainModel?.dailyCheckInResult?.targetSleepQuantity == source.domainModel?.dailyCheckInResult?.targetSleepQuantity
    }

    static func createAttributedImpactReadinessTitle(for readinessScore: Int?, impactReadinessNoDataTitle: String?) -> NSAttributedString {
        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        guard readinessScore != -1 else {
            return NSAttributedString.init(string: impactReadinessNoDataTitle ?? "", attributes: firstAttributes)
        }

        let impactReadinessAttrString = NSMutableAttributedString(string: "\(readinessScore ?? 0)", attributes: firstAttributes)
        let outOfAttrString = NSAttributedString(string: " out of 100", attributes: secondAttributes)

        impactReadinessAttrString.append(outOfAttrString)

        return impactReadinessAttrString
    }
}
