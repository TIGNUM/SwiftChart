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

    @objc private(set) dynamic var featureLink: String = ""

    @objc private(set) dynamic var contentID: Int = 0

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var block: Int = 0

    @objc dynamic var completedAt: Date?

    @objc dynamic var displayTime: Date?

    @objc dynamic var reminderTime: Date?

    var itemType = ItemType.strategy
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
        itemType = ItemType(rawValue: data.title) ?? itemType
        greeting = data.greeting
        link = data.link
        featureLink = data.featureLink
        contentID = data.contentID
        priority = data.priority
        block = data.block
        setupDisplayTime(data)
        setupReminderTime(data)
    }

    private func setupDisplayTime(_ data: GuideItemLearnIntermediary) {
        guard let time = data.displayTime else { return }

        displayTime = DateComponents.timeComponents(time).date
    }

    private func setupReminderTime(_ data: GuideItemLearnIntermediary) {
        guard let time = data.reminderTime else { return }

        reminderTime = DateComponents.timeComponents(time).date
    }
}
