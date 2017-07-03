//
//  QuestionIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct QuestionIntermediary {

    let sortOrder: Int
    let title: String
    let subtitle: String?
    let answersDescription: String?
    let answers: [AnswerIntermediary]

    init(sortOrder: Int, title: String, subtitle: String?, answersDescription: String?, answers: [AnswerIntermediary]) {
        self.sortOrder = sortOrder
        self.title = title
        self.subtitle = subtitle
        self.answersDescription = answersDescription
        self.answers = answers
    }
}

extension QuestionIntermediary: JSONDecodable {

    init(json: JSON) throws {
        self.sortOrder = (try json.getItemValue(at: .sortOrder) as Int?) ?? 0
        self.title = try json.getItemValue(at: .question)
        self.subtitle = try json.getItemValue(at: .subtitle)
        self.answersDescription = try json.getItemValue(at: .questionDescription)

        let questionGroups = try json.getArray(at: JsonKey.questionGroups.value).map { try QuestionGroup(json: $0) }.dictionary
        let answers = try json.getArray(at: JsonKey.answers.value).map { (answerJSON) -> [AnswerIntermediary] in
            return try answersWith(json: answerJSON, questionGroup: questionGroups)
        }
        self.answers = answers.flatMap { $0 }
    }
}

// MARK: Private helpers

private func answersWith(json: JSON, questionGroup: [Int: String]) throws -> [AnswerIntermediary] {

    let sortOrder: Int? = try json.getItemValue(at: .sortOrder)
    let title: String = try json.getString(at: JsonKey.answer.rawValue, or: "")
    let subtitle: String? = try json.getItemValue(at: .subtitle)

    return try json.getArray(at: JsonKey.decisions.value).map { (decisionJSON) in
        guard let group = questionGroup[try decisionJSON.getItemValue(at: .questionGroupId)] else {
            throw JSON.Error.valueNotConvertible(value: decisionJSON, to: AnswerIntermediary.self)
        }
        return AnswerIntermediary(sortOrder: sortOrder ?? 0,
                                  group: group,
                                  title: title,
                                  subtitle: subtitle,
                                  targetType: try decisionJSON.getItemValue(at: .targetType),
                                  targetID: try decisionJSON.getItemValue(at: .targetTypeId),
                                  targetGroup: try decisionJSON.getItemValue(at: .targetGroupName))
    }
}

private struct QuestionGroup {

    let id: Int
    let name: String

    init(json: JSON) throws {
        self.id = try json.getItemValue(at: .id)
        self.name = try json.getItemValue(at: .name)
    }
}

private extension Array where Element == QuestionGroup {

    var dictionary: [Int: String] {
        var dict: [Int: String] = [:]
        for group in self {
            dict[group.id] = group.name
        }
        return dict
    }
}
