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

final class GuideItem: SyncableObject {

    @objc private(set) dynamic var planItemID: Int = 0

    @objc private(set) dynamic var title: String?

    @objc private(set) dynamic var body: String = ""

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var typeDisplayString: String = ""

    @objc private(set) dynamic var greeting: String?

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var completedAt: Date?

    var status = GuideViewModel.Status.todo

    convenience init(planItemID: Int,
                     title: String,
                     body: String,
                     type: String,
                     greeting: String,
                     link: String,
                     priority: Int,
                     completedAt: Date?) {
        self.init(planItemID: planItemID,
                  title: title,
                  body: body,
                  type: type,
                  greeting: greeting,
                  link: link,
                  priority: priority,
                  completedAt: completedAt)
        status = completedAt == nil ? .todo : .done
    }
}
