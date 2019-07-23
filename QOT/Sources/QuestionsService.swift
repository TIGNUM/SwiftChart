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
}

// MARK: - Question Filtering

extension QuestionsService {

    func question(id: Int) -> Question? {
        return mainRealm.syncableObject(ofType: Question.self, remoteID: id)
    }

    func question(for key: String) -> Question? {
        let predicate = NSPredicate(format: "key == %@", key)
        return mainRealm.objects(Question.self).sorted(by: [.sortOrder()]).filter(predicate).first
    }

    func prepareQuestions(questionGroupID: Int) -> AnyRealmCollection<Question> {
        return questions(for: questionGroupID)
    }

    func recoveryQuestions() -> AnyRealmCollection<Question> {
        return questions(for: 100051)
    }
}

// MARK: - Morning Interview

extension QuestionsService {

    func morningInterviewQuestions(questionGroupID: Int) -> AnyRealmCollection<Question> {
        let predicate = NSPredicate(format: "ANY groups.id == %d AND answers.@count > 0", questionGroupID)
        let results = mainRealm.objects(Question.self).sorted(by: [.sortOrder()]).filter(predicate)
        return AnyRealmCollection(results)
    }

    func morningInterviewTitles(questionGroupID: Int) -> [String] {
        let questions = morningInterviewQuestions(questionGroupID: questionGroupID)
        return Array(questions).compactMap { $0.title }
    }
}

// MARK: - 3D Recovery
extension QuestionsService {
    func recoveryIntro() -> Question? {
        return question(for: QuestionKey.Recovery.intro.rawValue)
    }

    func answer(for id: Int) -> Answer? {
        return Array(recoveryQuestions().flatMap { $0.answers }).filter { $0.remoteID.value == id }.first
    }
}

// MARK: - Private
private extension QuestionsService {

    func questions(for questionGroupID: Int) -> AnyRealmCollection<Question> {
        let predicate = NSPredicate(format: "ANY groups.id == %d", questionGroupID)
        let results = mainRealm.objects(Question.self).sorted(by: [.sortOrder()]).filter(predicate)
        return AnyRealmCollection(results)
    }
}
