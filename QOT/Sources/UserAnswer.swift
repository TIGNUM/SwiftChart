//
//  UserAnswer.swift
//  QOT
//
//  Created by Lee Arromba on 09/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

final class UserAnswer: SyncableObject {

    @objc dynamic var questionID: Int = 0

    @objc dynamic var questionGroupID: Int = 0

    @objc dynamic var answerID: Int = 0

    @objc dynamic var userAnswer: String = ""

    @objc dynamic var notificationID: Int = 0

    convenience init(questionID: Int, questionGroupID: Int, answerID: Int, userAnswer: String, notificationID: Int) {
        self.init()
        self.questionID = questionID
        self.questionGroupID = questionGroupID
        self.answerID = answerID
        self.userAnswer = userAnswer
        self.notificationID = notificationID
    }
}

// MARK: - OneWaySyncableUp

extension UserAnswer: OneWaySyncableUp {

    static var endpoint: Endpoint {
        return .userAnswer
    }

    func toJson() -> JSON? {
        let dateFormatter = DateFormatter.iso8601
        let dict: [JsonKey: JSONEncodable] = [
            .qotId: localID,
            .questionGroupId: questionGroupID,
            .answerId: answerID,
            .questionId: questionID,
            .userAnswer: userAnswer,
            .notificationId: notificationID,
            // FIXME: `validFrom` && `validUntil` can be deleted when the API handles `notificationId`.
            // Check with Matthias. Should be fine to delete by February 09 2018.
            .validFrom: dateFormatter.string(from: Date()),
            .validUntil: dateFormatter.string(from: Date())
        ]
        let FIXME_WARNING = "DELETE validFrom && validUntil"
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
