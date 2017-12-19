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

protocol RealmGuideItemProtocol: class {

    var completedAt: Date? { get set }
    var priority: Int { get }
}

final class RealmGuideItem: Object {

    @objc dynamic var localID: String = ""

    @objc dynamic var guideItemLearn: RealmGuideItemLearn?

    @objc dynamic var guideItemNotification: RealmGuideItemNotification?

    @objc dynamic var completedAt: Date?

    convenience init(item: RealmGuideItemLearn, date: Date) {
        self.init()
        self.guideItemLearn = item
        self.completedAt = item.completedAt
        self.localID = GuideItemID(date: date, item: item).stringRepresentation
    }

    convenience init(item: RealmGuideItemNotification, date: Date) {
        self.init()
        self.guideItemNotification = item
        self.completedAt = item.completedAt
        self.localID = GuideItemID(date: date, item: item).stringRepresentation
    }

    override class func primaryKey() -> String? {
        return "localID"
    }
}

extension RealmGuideItem {

    var priority: Int {
        return referencedItem?.priority ?? 0
    }

    var referencedItem: RealmGuideItemProtocol? {
        if let guideItemLearn = guideItemLearn {
            return guideItemLearn
        } else if let guideItemNotification = guideItemNotification {
            return guideItemNotification
        } else {
            return nil
        }
    }
}
