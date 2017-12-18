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

final class RealmGuideItem: Object {

    @objc dynamic var guideItemLearn: RealmGuideItemLearn?

    @objc dynamic var guideItemNotification: RealmGuideItemNotification?

    @objc private(set) dynamic var completedAt: Date?

    convenience init(itemLearn: RealmGuideItemLearn) {
        self.init()
        self.guideItemLearn = itemLearn
    }

    convenience init(itemNotification: RealmGuideItemNotification) {
        self.init()
        self.guideItemNotification = itemNotification
    }
}

extension RealmGuideItem {

    var priority: Int {
        if let guideItemLearn = guideItemLearn {
            return guideItemLearn.priority
        } else if let guideItemNotification = guideItemNotification {
            return guideItemNotification.priority
        } else {
            return 0
        }
    }
}
