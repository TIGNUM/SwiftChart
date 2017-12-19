//
//  GuideItemLearn.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

extension RealmGuideItemLearn {

    enum ItemType: String {
        case strategy = "LEARN_STRATEGIES"
        case feature = "FEATURE_EXPLAINER"
    }
}

final class RealmGuideItemLearn: SyncableObject {

    @objc private(set) dynamic var title: String = ""

    @objc private(set) dynamic var body: String = ""

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var displayType: String = ""

    @objc private(set) dynamic var greeting: String = ""

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var sound: String = ""

    @objc private(set) dynamic var featureLink: String = ""

    @objc private(set) dynamic var contentID: Int = 0

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var block: Int = 0

    @objc dynamic var completedAt: Date?

    @objc dynamic var displayTime: RealmGuideTime?

    @objc dynamic var reminderTime: RealmGuideTime?
}

extension RealmGuideItemLearn: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .guideItemsLearn
    }

    func setData(_ data: GuideItemLearnIntermediary, objectStore: ObjectStore) throws {
        title = data.title
        body = data.body
        type = data.type
        displayType = data.displayType
        greeting = data.greeting
        link = data.link
        sound = data.sound
        featureLink = data.featureLink
        contentID = data.contentID
        priority = data.priority
        block = data.block

        if let displayTime = data.displayTime {
            self.displayTime = RealmGuideTime(displayTime)
        }

        if let reminderTime = data.reminderTime {
            self.reminderTime = RealmGuideTime(reminderTime)
        }
    }
}
