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
    
    @objc dynamic var validFrom: Date = Date()
    
    @objc dynamic var validUntil: Date = Date()
    
    convenience init(questionID: Int, questionGroupID: Int, answerID: Int, userAnswer: String, validFrom: Date, validUntil: Date) {
        self.init()
        self.questionID = questionID
        self.questionGroupID = questionGroupID
        self.answerID = answerID
        self.userAnswer = userAnswer
        self.validFrom = validFrom
        self.validUntil = validUntil
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
            .validFrom: dateFormatter.string(from: validFrom),
            .validUntil: dateFormatter.string(from: validUntil)
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
