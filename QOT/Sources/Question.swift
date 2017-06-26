//
//  Question.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class Question: Object {

    dynamic var remoteID: Int = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    override class func primaryKey() -> String? {
        return "remoteID"
    }

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var group: String = ""

    fileprivate(set) dynamic var text: String = ""

    fileprivate(set) dynamic var answersDescription: String?

    let answers = List<Answer>()
}

extension Question: DownSyncable {
    static func make(remoteID: Int, createdAt: Date) -> Question {
        let question = Question()
        question.remoteID = remoteID
        question.createdAt = createdAt
        return question
    }

    func setData(_ data: QuestionIntermediary, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        group = data.group
        text = data.text
        answersDescription = data.answersDescription

        objectStore.delete(answers)
        let newAnswers = data.answers.map { Answer(intermediary: $0) }
        answers.append(objectsIn: newAnswers)
    }
}
