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
    }
}

extension RealmGuideItemNotification {

    struct DailyPrepItem {
        var feedback: String?
        var results: [Int]
        var link: String
        var title: String?
        var body: String
        var greeting: String?
        var issueDate: Date
        var status: GuideViewModel.Status
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

    @objc dynamic var completed: Bool = false

    @objc dynamic var morningInterviewFeedback: String?

    @objc dynamic var displayTime: Date?

    @objc dynamic var reminderTime: Date?

    var morningInterviewResults: List<IntObject> = List()
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
        priority = data.priority
        issueDate = data.issueDate
        setupDisplayTime(data)
        setupReminderTime(data)
    }

    private func setupDisplayTime(_ data: GuideItemNotificationIntermediary) {
        guard let time = data.displayTime else { return }

        displayTime = DateComponents.timeComponents(time).date
    }

    private func setupReminderTime(_ data: GuideItemNotificationIntermediary) {
        guard let time = data.reminderTime else { return }

        reminderTime = DateComponents.timeComponents(time).date
    }
}
