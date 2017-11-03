//
//  QuestionGroup.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class QuestionGroup: Object {

    @objc private(set) dynamic var id: Int = 0

    @objc private(set) dynamic var name: String = ""

    convenience init(intermediary: QuestionGroupIntermediary) {
        self.init()

        id = intermediary.id
        name = intermediary.name
    }

    func delete() {
        if let realm = realm {
            realm.delete(self)
        }
    }
}
