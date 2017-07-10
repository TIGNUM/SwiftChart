//
//  AnswerDecision.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class AnswerDecision: Object {

    private let _targetID = RealmOptional<Int>(nil)

    private let _targetGroupID = RealmOptional<Int>(nil)

    fileprivate(set) dynamic var id: Int = 0

    fileprivate(set) dynamic var questionGroupID: Int = 0

    fileprivate(set) dynamic var targetType: String?

    var targetID: Int? {
        return _targetID.value
    }

    var targetGroupID: Int? {
        return _targetGroupID.value
    }

    convenience init(intermediary: AnswerDecisionIntermediary) {
        self.init()

        id = intermediary.id
        questionGroupID = intermediary.questionGroupID
        targetType = intermediary.targetType
        _targetID.value = intermediary.targetID
        _targetGroupID.value = intermediary.targetGroupID
    }
}
