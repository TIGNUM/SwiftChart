//
//  GuidePlanItemLearn.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

extension GuidePlanItemLearn {

    enum GuidePlanItemType: String {
        case strategy = "LEARN_STRATEGIES"
        case featureExplainer = "FEATURE_EXPLAINER"
    }
}

final class GuidePlanItemLearn: SyncableObject {

    @objc private(set) dynamic var title: String = ""

    @objc private(set) dynamic var body: String = ""

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var greeting: String = ""

    @objc private(set) dynamic var link: String = ""

    @objc private(set) dynamic var priority: Int = 0

    @objc private(set) dynamic var day: Int = 0

    @objc private(set) dynamic var reminderTime: Date = Date()

    @objc dynamic var completed: Bool = false

    var itemType: GuidePlanItemType = .strategy
}

extension GuidePlanItemLearn: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .guidePlanItemLearn
    }

    func setData(_ data: GuidePlanItemLearnIntermediary, objectStore: ObjectStore) throws {        
        title = data.title
        body = data.body
        type = data.type
        itemType = GuidePlanItemType(rawValue: data.title) ?? itemType
        greeting = data.greeting
        link = data.link
        priority = Int(data.priority) ?? 0
        day = Int(data.day) ?? 0
        reminderTime = data.reminderTime
    }
}
