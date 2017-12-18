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

    @objc private(set) dynamic var typeDisplayString: String = ""

    @objc private(set) dynamic var greeting: String = ""

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var featureLink: String = ""

    @objc private(set) dynamic var contentID: Int = 0

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var block: Int = 0

    @objc dynamic var completedAt: Date?

    var reminderTime: DateComponents = DateComponents()

    var displayTime: DateComponents = DateComponents()

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
        typeDisplayString = data.typeDisplayString
        itemType = ItemType(rawValue: data.title) ?? itemType
        greeting = data.greeting
        link = data.link
        featureLink = data.featureLink
        contentID = data.contentID
        priority = data.priority
        block = data.block
        reminderTime = DateComponents.timeComponents(data.reminderTime)
        displayTime = DateComponents.timeComponents(data.displayTime)
    }
}
