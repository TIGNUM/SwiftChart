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

    func prepareQuestions(questionGroupID: Int) -> AnyRealmCollection<Question> {
        let predicate = NSPredicate(format: "ANY answers.decisions.questionGroupID == %d", questionGroupID)
        let results = mainRealm.objects(Question.self).sorted(by: [.sortOrder()]).filter(predicate)
        return AnyRealmCollection(results)
    }

    func question(id: Int) -> Question? {
        return mainRealm.syncableObject(ofType: Question.self, remoteID: id)
    }

    func morningInterviewQuestions(questionGroupID: Int) -> AnyRealmCollection<Question> {
        let predicate = NSPredicate(format: "ANY groups.id == %d AND answers.@count > 0", questionGroupID)
        let results = mainRealm.objects(Question.self).sorted(by: [.sortOrder()]).filter(predicate)

        return AnyRealmCollection(results)
    }

    func morningInterviewTitles(questionGroupID: Int) -> [String] {
        let questions = morningInterviewQuestions(questionGroupID: questionGroupID)
        return Array(questions).flatMap { $0.title }
    }

    func target(answer: Answer, questionGroupID id: Int) -> AnswerDecision.Target? {
        let decisions = answer.decisions.filter(.questionGroupIDis(id))
        for decision in decisions {
            if let target = decision.target {
                switch target {
                case .content(let id):
                    if mainRealm.syncableObject(ofType: ContentCollection.self, remoteID: id) != nil {
                        return target
                    }
                case .question(let id):
                    if question(id: id) != nil {
                        return target
                    }
                }
            }
        }
        return nil
    }
}
