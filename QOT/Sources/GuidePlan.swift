//
//  Guide.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class GuidePlan: SyncableObject {

    @objc dynamic var planID: String = ""

    @objc dynamic var greeting: String = ""

    @objc dynamic var planingTime: String  = ""

    @objc dynamic var planDay: String = ""

    var learnItems = List<GuidePlanItemLearn>()

    var notificationItems = List<GuidePlanItemNotification>()

    @objc dynamic var changeStamp: String? = UUID().uuidString

    convenience init(learnItems: List<GuidePlanItemLearn>, notificationItems: List<GuidePlanItemNotification>) {
        self.init()

        self.learnItems = learnItems
        self.notificationItems = notificationItems
    }
}

extension GuidePlan: OneWaySyncableUp {

    func toJson() -> JSON? {
        let dict: [JsonKey: JSONEncodable] = [:]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

    static var endpoint: Endpoint {
        return .guidePlan
    }
}
