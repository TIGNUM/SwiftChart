//
//  MyToBeVisionRateViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct RatingQuestionViewModel {
    struct Answer {
        let remoteID: Int?
        let title: String?
        let subtitle: String?
    }

    class Question: RatingQuestionnaire {
        let remoteID: Int?
        let title: String
        let htmlTitle: String?
        let subtitle: String?
        let dailyPrepTitle: String?
        let key: String?
        let answers: [Answer]?
        let range: Int?
        let toBeVisionTrackId: Int?
        let SHPIQuestionId: Int?
        let groups: [QDMQuestionGroup]?
        let buttonText: String?
        var selectedAnswerIndex: Int?

        init?(remoteID: Int?, title: String, htmlTitle: String?,
              subtitle: String?, dailyPrepTitle: String?,
              key: String?, answers: [Answer]?,
              range: Int?, toBeVisionTrackId: Int? = nil,
              SHPIQuestionId: Int? = nil, groups: [QDMQuestionGroup]? = nil ,
              buttonText: String? = nil, selectedAnswerIndex: Int?) {
            self.remoteID = remoteID
            self.title = title
            self.htmlTitle = htmlTitle
            self.subtitle = subtitle
            self.dailyPrepTitle = dailyPrepTitle
            self.key = key
            self.answers = answers
            self.range = range
            self.toBeVisionTrackId = toBeVisionTrackId
            self.SHPIQuestionId = SHPIQuestionId
            self.groups = groups
            self.buttonText = buttonText
            self.selectedAnswerIndex = selectedAnswerIndex
        }

        func items() -> Int? {
            return range ?? answers?.count
        }

        func getAnswers() -> [Answer]? {
            return answers
        }

        func questionKey() -> String? {
            return key
        }

        func selectedQuestionAnswerIndex() -> Int? {
            return selectedAnswerIndex
        }

        func questionIdentifier() -> Int? {
            return remoteID
        }

        func questionHtml() -> NSAttributedString? {
            return htmlTitle?.convertHtml()
        }

        func questionText() -> String? {
            return title
        }

        func selectedAnswer() -> Answer? {
            guard let index = selectedAnswerIndex else { return nil }
            return answers?[index]
        }
    }
}
