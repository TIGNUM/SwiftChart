//
//  QuestionsService.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class QuestionsService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func prepareQuestions() -> AnyRealmCollection<Question> {
        let predicate = NSPredicate(format: "ANY answers.group == %@", Database.QuestionGroup.PREPARE.rawValue)
        let results = mainRealm.objects(Question.self).sorted(byKeyPath: "sortOrder").filter(predicate)
        return AnyRealmCollection(results)
    }

    func question(id: Int) -> Question? {
        return mainRealm.object(ofType: Question.self, forPrimaryKey: id)
    }
}
