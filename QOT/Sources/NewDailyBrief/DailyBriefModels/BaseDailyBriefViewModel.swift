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

class BaseDailyBriefViewModel: Differentiable, DynamicHeightProtocol {

    // MARK: - Properties
    typealias DifferenceIdentifier = String
    var caption: String?
    var title: String?
    var attributedTitle: NSAttributedString?
    var attributedBody: NSAttributedString?
    var body: String?
    var image: String?
    var domainModel: QDMDailyBriefBucket?
    var subIdentifier = ""
    var titleColor: String? = "9C9897"

    // MARK: - Init
    init(_ domainModel: QDMDailyBriefBucket?,
         _ subIdentifier: String? = "",
         caption: String? = "",
         title: String? = "",
         body: String? = "",
         image: String? = "",
         titleColor: String? = "#9C9897") {
        self.domainModel = domainModel
        self.subIdentifier = subIdentifier ?? ""
        self.caption = caption
        self.title = title
        self.body = body
        self.attributedTitle = ThemeText.dailyBriefTitle.attributedString(title)
        self.attributedBody = ThemeText.bodyText.attributedString(body)
        self.image = image
        self.titleColor = titleColor
    }

    var differenceIdentifier: DifferenceIdentifier {
        return (self.domainModel?.bucketName ?? "") + subIdentifier
    }

    func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        return caption == source.caption &&
            title == source.title &&
            titleColor == source.titleColor &&
            body == source.body &&
            image == source.image &&
            domainModel?.toBeVisionId == source.domainModel?.toBeVisionId &&
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

    // MARK: - Public
    public func height(forWidth width: CGFloat) -> CGFloat {
        return .zero
    }
}
