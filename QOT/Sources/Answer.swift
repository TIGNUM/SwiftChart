//
//  Answer.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

class Answer: Object {

    // MARK: Private

    private let _targetID = RealmOptional<Int>(nil)

    // MARK: Public

    fileprivate(set) dynamic var text: String = ""

    fileprivate(set) dynamic var targetType: String?

    fileprivate(set) dynamic var targetGroup: String?

    var targetID: Int? {
        return _targetID.value
    }

    convenience init(intermediary: AnswerIntermediary) {
        self.init()

        self.text = intermediary.text
        self.targetType = intermediary.targetType
        self._targetID.value = intermediary.targetID
        self.targetGroup = intermediary.targetGroup
    }
}
