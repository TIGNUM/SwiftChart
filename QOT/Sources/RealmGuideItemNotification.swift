//
//  GuideItemNotification.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy
import UserNotifications

extension RealmGuideItemNotification {

    enum ItemType: String {
        case morningInterview = "MORNING_INTERVIEW"
        case morningInterviewReminder = "MORNING_INTERVIEW_REMINDER"
        case weeklyInterview = "WEEKLY_INTERVIEW"
        case toBeVision = "TOBEVISION"
        case randomContentSleep = "RANDOM_CONTENT_SLEEP"
        case randomContentMovement = "RANDOM_CONTENT_MOVEMENT"
        case fitBitSyncReminder = "FITBIT_SYNC_REMINDER"
    }
}

final class RealmGuideItemNotification: SyncableObject {

    @objc private dynamic var _dailyPrepFeedback: String?

    @objc private(set) dynamic var title: String?

    @objc private(set) dynamic var body: String = ""

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var displayType: String = ""

    @objc private(set) dynamic var greeting: String = ""

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var sound: String = ""

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var issueDate: Date?

    @objc dynamic var completedAt: Date?

    @objc dynamic var displayTime: RealmGuideTime?

    @objc dynamic var reminderTime: RealmGuideTime?

    @objc dynamic var interviewResult: RealmInterviewResult?

    @objc dynamic var localNofiticationScheduled: Bool = false

    /*
     We init this as dirty to force an update after first creation. We do this so that the servers serverPush value is
     updated after a logout etc.
    */
    @objc dynamic var guideItem: RealmGuideItem? = RealmGuideItem(dirty: true)

    func didUpdate() {
        guideItem?.didUpdate()
    }

    var dailyPrepFeedback: String? {
        return interviewResult?.feedback ?? _dailyPrepFeedback
    }
}

extension RealmGuideItemNotification {

    var isDailyPrep: Bool {
        guard let itemType = ItemType(rawValue: type) else { return false }

        return itemType == .morningInterview || itemType == .weeklyInterview
    }

    var guideItemID: GuideItemID {
        return GuideItemID(item: self)
    }

    var localNotificationDate: Date? {
        guard let issueDate = issueDate, let reminderTime = reminderTime else { return nil }
        return reminderTime.date(with: issueDate)
    }

    var notificationRequest: UNNotificationRequest? {
        guard let triggerDate = localNotificationDate, isDailyPrep == false else { return nil }

        let content = UNMutableNotificationContent(title: title, body: body, soundName: sound, link: link)

        if sound.isEmpty == true {
            content.sound = nil
        }

        let trigger = UNCalendarNotificationTrigger(localTriggerDate: triggerDate)
        return UNNotificationRequest(identifier: guideItemID.stringRepresentation, content: content, trigger: trigger)
    }
}

extension RealmGuideItemNotification: BuildRelations {

    func buildRelations(realm: Realm) {
        if let remoteID = remoteID.value {
            interviewResult = realm.object(ofType: RealmInterviewResult.self, forPrimaryKey: remoteID)
        }
    }
}

extension RealmGuideItemNotification: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .guideItemsNotification
    }

    func setData(_ data: GuideItemNotificationIntermediary, objectStore: ObjectStore) throws {
        title = data.title
        body = data.body
        type = data.type
        displayType = data.displayType
        greeting = data.greeting
        link = data.link
        sound = data.sound
        priority = data.priority
        issueDate = data.issueDate

        if data.completedAt != nil {
            completedAt = data.completedAt
        }

        if data.feedback != nil {
            _dailyPrepFeedback = data.feedback
        }

        if let displayTime = data.displayTime {
            self.displayTime = RealmGuideTime(displayTime)
        }

        if let reminderTime = data.reminderTime {
            self.reminderTime = RealmGuideTime(reminderTime)
        }
    }
}
