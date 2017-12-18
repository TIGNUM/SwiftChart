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

    @objc dynamic var guideItemLearn: GuideItemLearn?

    @objc dynamic var guideItemNotification: GuideItemNotification?

    @objc private(set) dynamic var completedAt: Date?

    convenience init(itemLearn: GuideItemLearn) {
        self.init()
        self.guideItemLearn = itemLearn
    }

    convenience init(itemNotification: GuideItemNotification) {
        self.init()
        self.guideItemNotification = itemNotification
        LocalNotificationBuilder.shared.create(notification: itemNotification)
    }
}

extension GuideItem {

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
