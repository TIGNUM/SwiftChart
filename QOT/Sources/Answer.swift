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

    private let _nextID = RealmOptional<Int>(nil)

    // MARK: Public

    fileprivate(set) dynamic var text: String = ""

    fileprivate(set) dynamic var nextType: String?

    var nextID: Int? {
        return _nextID.value
    }

    convenience init(intermediary: AnswerIntermediary) {
        self.init()

        self.text = intermediary.text
        self.nextType = intermediary.nextType
        self._nextID.value = intermediary.nextID
    }
}
