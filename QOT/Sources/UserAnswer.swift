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

    @objc dynamic var deleted: Bool = false

    @objc dynamic var changeStamp: String?

    convenience init(questionID: Int,
                     questionGroupID: Int,
                     answerID: Int,
                     userAnswer: String,
                     notificationID: Int) {
        self.init()
        self.questionID = questionID
        self.questionGroupID = questionGroupID
        self.answerID = answerID
        self.userAnswer = userAnswer
        self.notificationID = notificationID
        didUpdate()
    }
}

// MARK: - TwoWaySyncable

extension UserAnswer: TwoWaySyncable {

    static var endpoint: Endpoint {
        return .userAnswer
    }

    func setData(_ data: UserAnswerIntermediary, objectStore: ObjectStore) throws {
        questionID = data.questionID
        questionGroupID = data.questionGroupID
        answerID = data.answerID
        userAnswer = data.userAnswer
        notificationID = data.notificationID ?? 0
    }

    func toJson() -> JSON? {
        let dateFormatter = DateFormatter.iso8601
        let dict: [JsonKey: JSONEncodable] = [
            .id: remoteID.value.toJSONEncodable,
            .createdAt: dateFormatter.string(from: createdAt),
            .modifiedAt: dateFormatter.string(from: modifiedAt),
            .qotId: localID,
            .questionGroupId: questionGroupID,
            .answerId: answerID,
            .questionId: questionID,
            .userAnswer: userAnswer,
            .notificationId: notificationID,
            .validFrom: JSON.null,
            .validUntil: JSON.null
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
