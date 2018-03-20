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

    @objc dynamic var isoDate: String = "" // Eg. "2018-01-31"

    convenience init(questionID: Int,
                     questionGroupID: Int,
                     answerID: Int,
                     userAnswer: String,
                     date: ISODate) {
        self.init()
        self.questionID = questionID
        self.questionGroupID = questionGroupID
        self.answerID = answerID
        self.userAnswer = userAnswer
        self.isoDate = date.string
    }
}

// MARK: - TwoWaySyncable

extension UserAnswer: OneWaySyncableUp {

    static var endpoint: Endpoint {
        return .userAnswer
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
            .isodate: isoDate
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
