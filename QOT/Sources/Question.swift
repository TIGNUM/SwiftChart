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

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var title: String = ""

    fileprivate(set) dynamic var subtitle: String?

    fileprivate(set) dynamic var answersDescription: String?

    let answers = List<Answer>()

    let groups = List<QuestionGroup>()
}

extension Question: DownSyncable {

    func setData(_ data: QuestionIntermediary, objectStore: ObjectStore) throws {
        answers.forEach { $0.delete() }
        groups.forEach { $0.delete() }

        sortOrder = data.sortOrder
        title = data.title
        answersDescription = data.answersDescription
        answers.append(objectsIn: data.answers.map({ Answer(intermediary: $0) }))
        groups.append(objectsIn: data.groups.map({ QuestionGroup(intermediary: $0) }))        
    }
}
