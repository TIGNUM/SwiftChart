//
//  GuideItem.swift
//  QOT
//
//  Created by karmic on 13.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class GuideItem: Object {

    @objc private(set) dynamic var planItemID: Int = 0

    @objc private(set) dynamic var title: String?

    @objc private(set) dynamic var body: String = ""

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var typeDisplayString: String = ""

    @objc private(set) dynamic var greeting: String?

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var block: Int = 0

    @objc private(set) dynamic var completedAt: Date?

    @objc private(set) dynamic var feedback: String?

    var dailyPrepResults: List<IntObject> = List()

    var status = GuideViewModel.Status.todo

    convenience init(planItemID: Int,
                     title: String,
                     body: String,
                     type: String,
                     typeDisplayString: String,
                     greeting: String,
                     link: String,
                     priority: Int,
                     block: Int,
                     completedAt: Date?) {
        self.init(planItemID: planItemID,
                  title: title,
                  body: body,
                  type: type,
                  typeDisplayString: typeDisplayString,
                  greeting: greeting,
                  link: link,
                  priority: priority,
                  block: block,
                  completedAt: completedAt)
        status = completedAt == nil ? .todo : .done
    }

    convenience init(_ data: GuideItemIntermediary) {
        self.init()

        planItemID = data.planItemID
        title = data.title
        body = data.body
        type = data.type
        typeDisplayString = data.typeDisplayString
        greeting = data.greeting
        link = data.link
        priority = data.priority
        block = data.block
        completedAt = data.completedAt
        feedback = data.feedback
        dailyPrepResults.forEach { $0.delete() }
        dailyPrepResults.append(objectsIn: data.dailyPrepResults.map { IntObject(int: $0) })
    }
}
