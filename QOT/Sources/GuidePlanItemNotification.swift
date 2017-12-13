//
//  GuidePlanItemNotification.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

extension GuidePlanItemNotification {

    enum ItemType: String {
        case morningInterview = "MORNING_INTERVIEW"
        case toBeVision = "TOBEVISION"
        case randomContentSleep = "RANDOM_CONTENT_SLEEP"
    }
}

extension GuidePlanItemNotification {

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

final class GuidePlanItemNotification: SyncableObject {

    @objc private(set) dynamic var title: String?

    @objc private(set) dynamic var body: String = ""

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var greeting: String?

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var issueDate: Date = Date()

    @objc dynamic var completed: Bool = false

    @objc dynamic var morningInterviewFeedback: String = ""

    var morningInterviewResults: List<IntObject> = List()
}

extension GuidePlanItemNotification: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .guidePlanItemNotification
    }

    func setData(_ data: GuidePlanItemNotificationIntermediary, objectStore: ObjectStore) throws {
        title = data.title
        body = data.body
        type = data.type
        greeting = data.greeting
        link = data.link
        priority = data.priority
        issueDate = data.issueDate
    }
}
