//
//  Question.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class Question: SyncableObject {

    @objc private(set) dynamic var sortOrder: Int = 0

    @objc private(set) dynamic var title: String = ""

    @objc private(set) dynamic var dailyPrepTitle: String = ""

    @objc private(set) dynamic var subtitle: String?

    @objc private(set) dynamic var key: String?

    @objc private(set) dynamic var answersDescription: String?

    let answers = List<Answer>()

    let groups = List<QuestionGroup>()    
}

extension Question: OneWaySyncableDown {

    func delete() {
        if let realm = realm {
            realm.delete(self)
        }
    }

    static var endpoint: Endpoint {
        return .question
    }

    func setData(_ data: QuestionIntermediary, objectStore: ObjectStore) throws {
        answers.forEach { $0.delete() }
        groups.forEach { $0.delete() }

        sortOrder = data.sortOrder
        title = data.title
        dailyPrepTitle = data.dailyPrepTitle
        answersDescription = data.answersDescription
        key = data.answers.filter { $0.title == "key" }.first?.subtitle
        answers.append(objectsIn: data.answers.filter { $0.title != "key" && $0.syncStatus != 2 /*2 = DELETED*/ }.map({ Answer(intermediary: $0) }))
        groups.append(objectsIn: data.groups.map({ QuestionGroup(intermediary: $0) }))
    }
}
