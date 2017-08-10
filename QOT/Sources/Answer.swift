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

    let remoteID = RealmOptional<Int>(nil)
    
    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var title: String = ""

    fileprivate(set) dynamic var subtitle: String?

    let decisions = List<AnswerDecision>()

    convenience init(intermediary: AnswerIntermediary) {
        self.init()

        self.remoteID.value = intermediary.remoteID
        self.sortOrder = intermediary.sortOrder
        self.title = intermediary.title
        self.subtitle = intermediary.subtitle
        self.decisions.append(objectsIn: intermediary.decisions.map { AnswerDecision(intermediary: $0) })
    }

    override func delete() {
        decisions.forEach { $0.delete() }
        super.delete()
    }
}
