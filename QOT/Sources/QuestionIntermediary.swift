//
//  QuestionIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct QuestionIntermediary: DownSyncIntermediary {
    let sortOrder: Int
    let title: String
    let htmlTitleString: String
    let dailyPrepTitle: String
    let answersDescription: String?
    let answers: [AnswerIntermediary]
    let groups: [QuestionGroupIntermediary]
    let answerType: String
    let key: String?
    let defaultButtonText: String?
    let confirmationButtonText: String?
    let maxPossibleSelections: Int?

    init(json: JSON) throws {
        sortOrder = try json.getItemValue(at: .sortOrder, fallback: 0)
        title = try json.getItemValue(at: .question, fallback: "")
        htmlTitleString = try json.getItemValue(at: .questionRichText, fallback: "")
        dailyPrepTitle = try json.getItemValue(at: .title, fallback: "")
        answersDescription = try json.getItemValue(at: .questionDescription)
        answers = try json.getArray(at: .answers, fallback: [])
        groups = try json.getArray(at: .questionGroups, fallback: [])
        answerType = try json.getItemValue(at: .answerType)
        key = try json.getItemValue(at: .key)
        defaultButtonText = try json.getItemValue(at: .defaultButtonText)
        confirmationButtonText = try json.getItemValue(at: .confirmationButtonText)
        maxPossibleSelections = try json.getItemValue(at: .maxPossibleSelections)
    }
}
