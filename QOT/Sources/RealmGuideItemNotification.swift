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

extension RealmGuideItemNotification {

    enum ItemType: String {
        case morningInterview = "MORNING_INTERVIEW"
        case toBeVision = "TOBEVISION"
        case randomContentSleep = "RANDOM_CONTENT_SLEEP"
        case randomContentMovement = "RANDOM_CONTENT_MOVEMENT"
    }
}

final class RealmGuideItemNotification: SyncableObject {

    @objc private(set) dynamic var title: String?

    @objc private(set) dynamic var body: String = ""

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var displayType: String = ""

    @objc private(set) dynamic var greeting: String?

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var sound: String = ""

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var issueDate: Date = Date()

    @objc dynamic var completedAt: Date?

    @objc dynamic var morningInterviewFeedback: String?

    @objc dynamic var displayTime: RealmGuideTime?

    @objc dynamic var reminderTime: RealmGuideTime?

    var dailyPrepResults = List<IntObject>()
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

        if let displayTime = data.displayTime {
            self.displayTime = RealmGuideTime(displayTime)
        }

        if let reminderTime = data.reminderTime {
            self.reminderTime = RealmGuideTime(reminderTime)
        }
    }
}
