//
//  RatingFeedbackModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class RatingFeedbackModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    let feedback: String?
    let averageValue: String?
    let team: QDMTeam?

    // MARK: - Init
    internal init(team: QDMTeam?, feedback: String?, averageValue: String?, imageURL: String?, domainModel: QDMDailyBriefBucket?) {
        self.feedback = feedback
        self.averageValue = averageValue
        self.team = team
        super.init(domainModel,
                   caption: AppTextService.get(.daily_brief_vision_suggestion_caption).replacingOccurrences(of: "${team}", with: team?.name ?? String.empty),
                   title: AppTextService.get(.daily_brief_rating_feedback_title),
                   body: feedback,
                   image: imageURL,
                   titleColor: team?.teamColor)
        self.attributedBody = RatingFeedbackModel.createAttributedBody(for: averageValue, feedback: feedback)
    }

    static func createAttributedBody(for average: String?, feedback: String?) -> NSAttributedString {
        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.lightGrey]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let bodyText = NSMutableAttributedString(string: AppTextService.get(.daily_brief_rating_feedback_body) + " ", attributes: firstAttributes)
        let averageValue = NSAttributedString(string: (average ?? String.empty) + "\n", attributes: secondAttributes)
        let feedbackText = NSAttributedString(string: feedback ?? String.empty, attributes: firstAttributes)
        bodyText.append(averageValue)
        bodyText.append(feedbackText)
        return bodyText
    }
}
