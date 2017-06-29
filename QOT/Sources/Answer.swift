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

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var group: String = ""

    fileprivate(set) dynamic var title: String = ""

    fileprivate(set) dynamic var subtitle: String?

    fileprivate(set) dynamic var targetType: String?

    fileprivate(set) dynamic var targetGroup: String?

    var targetID: Int? {
        return _targetID.value
    }

    convenience init(intermediary: AnswerIntermediary) {
        self.init()

        self.sortOrder = intermediary.sortOrder
        self.group = intermediary.group
        self.title = intermediary.title
        self.subtitle = intermediary.subtitle
        self.targetType = intermediary.targetType
        self.targetGroup = intermediary.targetGroup
        self._targetID.value = intermediary.targetID
    }
}
