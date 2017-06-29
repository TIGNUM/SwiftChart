//
//  MockData.swift
//  QOT
//
//  Created by Sam Wyndham on 10/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import LoremIpsum
import Alamofire

// FIXME: Remove when no longer needed

private let syncManager: SyncManager = {
    let requestBuilder = URLRequestBuilder(baseURL: URL(string: "http://example.com")!, deviceID: deviceID)
    let networkManager = MockNetworkManager(sessionManager: SessionManager.default, credentialsManager: CredentialsManager(), requestBuilder: requestBuilder)
    let realmProvider = RealmProvider()
    let syncRecordService = SyncRecordService(realmProvider: realmProvider)
    return SyncManager(networkManager: networkManager, syncRecordService: syncRecordService, realmProvider: realmProvider)
}()

/// Deletes all data in default realm and fills with mock data.
func setupRealmWithMockData(realm: Realm) {
    do {
        try realm.write {
            if realm.isEmpty {
                if MockToggle.json == true {
                    syncManager.syncAllMockJSONs()
                }

                try addQuestions(realm: realm)
            }
        }
    } catch let error {
        fatalError("Realm error: \(error)")
    }
}

var textItemJSON: String {
    var dict: [String: Any] = [:]
    dict["text"] = LoremIpsum.sentences(withNumber: Int.random(between: 5, and: 15))

    return jsonDictToString(dict: dict)
}

func jsonDictToString(dict: [String: Any]) -> String {
    if
        let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
        let string = String(data: data, encoding: .utf8) {
            return string
    } else {
        fatalError("Could not create textItemJSON!")
    }
}

// MARK: - Extensions

extension Int {
    /// Returns random number from `min` to `max` exclusive.
    static func random(between min: Int, and max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max) - UInt32(min))) + min
    }

    static var randomID: Int {
        return Int.random(between: 100000000, and: 999999999)
    }
}

private extension Array {
    func randomItem() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

// MARK: MOCK QUESTIONS

func addQuestions(realm: Realm) throws {
    // Prepare Question 1

    func answer(sortOrder: Int, title: String, targetType: String, targetID: Int) -> AnswerIntermediary {
        return AnswerIntermediary(sortOrder: sortOrder, group: "PREPARE", title: title, subtitle: nil, targetType: targetType, targetID: targetID, targetGroup: "PREPARE")
    }

    let firstAnswersIntermediaries = [
        answer(sortOrder: 0, title: "i want to prepare for an event", targetType: "QUESTION", targetID: 15001),
        answer(sortOrder: 0, title: "i want to check in with my normal tough day protocols", targetType: "QUESTION", targetID: 15001),
        answer(sortOrder: 0, title: "i struggle and i am looking for some solutions", targetType: "QUESTION", targetID: 15001)]

    let firstQuestionIntermediary = QuestionIntermediary(sortOrder: 0, title: "Hi Louis\nWhat are you preparing for?", subtitle: nil, answersDescription: nil, answers: firstAnswersIntermediaries)
    let firstQuestion = Question.make(remoteID: 15000, createdAt: Date())
    try firstQuestion.setData(firstQuestionIntermediary, objectStore: realm)

    // Prepare Question 2
    let secondAnswersIntermediaries = ["Meeting", "Negotiation", "Presentation", "Business dinner", "Pre-vacation", "High performance travel", "Work to home transition"].enumerated().map { (sort, title) -> AnswerIntermediary in
        answer(sortOrder: sort, title: title, targetType: "PREPARE_CONTENT", targetID: 1)
    }
    let secondQuestionIntermediary = QuestionIntermediary(sortOrder: 0, title: "Here is what you need", subtitle: nil, answersDescription: "PREPARATIONS", answers: secondAnswersIntermediaries)
    let secondQuestion = Question.make(remoteID: 15001, createdAt: Date())
    try secondQuestion.setData(secondQuestionIntermediary, objectStore: realm)

    realm.add([firstQuestion, secondQuestion])
}
