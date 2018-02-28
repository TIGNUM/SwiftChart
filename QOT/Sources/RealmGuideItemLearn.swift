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
import UserNotifications

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

    @objc private(set) dynamic var displayType: String?

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var sound: String = ""

    @objc private(set) dynamic var featureLink: String?

    @objc private(set) dynamic var featureButton: String?

    @objc private(set) dynamic var contentID: Int = 0

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var block: Int = 0

    @objc private(set) dynamic var greeting: String = ""

    @objc dynamic var completedAt: Date?

    @objc dynamic var displayTime: RealmGuideTime?

    @objc dynamic var reminderTime: RealmGuideTime?

    @objc dynamic var guideItem: RealmGuideItem?  = RealmGuideItem()

    func didUpdate() {
        guideItem?.didUpdate()
    }
}

extension RealmGuideItemLearn {

    var guideItemID: GuideItemID {
        return GuideItemID(item: self)
    }

    var localNotificationDate: Date? {
        return reminderTime?.date(with: Date())
    }

    var notificationRequest: UNNotificationRequest? {
        guard let triggerDate = localNotificationDate else { return nil }

        let content =  UNMutableNotificationContent(title: title, body: body, soundName: sound, link: link)
        let trigger = UNCalendarNotificationTrigger(localTriggerDate: triggerDate)
        return UNNotificationRequest(identifier: guideItemID.stringRepresentation, content: content, trigger: trigger)
    }
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
        featureButton = data.featureButton
        contentID = data.contentID
        priority = data.priority
        block = data.block

        if data.completedAt != nil {
            completedAt = data.completedAt
        }

        if let displayTime = data.displayTime {
            self.displayTime = RealmGuideTime(displayTime)
        }

        if let reminderTime = data.reminderTime {
            self.reminderTime = RealmGuideTime(reminderTime)
        }
    }
}
