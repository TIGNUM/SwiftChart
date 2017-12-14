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

final class Guide: SyncableObject {

    @objc dynamic var planID: String = ""

    @objc dynamic var greeting: String = ""

    @objc dynamic var planingTime: String  = ""

    @objc dynamic var deleted: Bool = false

    @objc dynamic var changeStamp: String? = UUID().uuidString

    var learnItems = List<GuideItemLearn>()

    var notificationItems = List<GuideItemNotification>()

    var items = List<GuideItem>()

    convenience init(learnItems: List<GuideItemLearn>,
                     notificationItems: List<GuideItemNotification>) {
        self.init()

        self.learnItems = learnItems
        self.notificationItems = notificationItems
    }

    func crateItems() {
        learnItems.forEach { (learnItem: GuideItemLearn) in
            let item = GuideItem(planItemID: learnItem.remoteID.value ?? 0,
                                 title: learnItem.title,
                                 body: learnItem.body,
                                 type: learnItem.body,
                                 typeDisplayString: learnItem.type,
                                 greeting: learnItem.greeting,
                                 link: learnItem.link,
                                 priority: learnItem.priority,
                                 block: learnItem.block,
                                 completedAt: nil)
            items.append(item)
        }

        notificationItems.forEach { (notificationItem: GuideItemNotification) in
            let item = GuideItem(planItemID: notificationItem.remoteID.value ?? 0,
                                 title: notificationItem.title ?? "",
                                 body: notificationItem.body,
                                 type: notificationItem.type,
                                 typeDisplayString: notificationItem.type,
                                 greeting: notificationItem.greeting ?? "",
                                 link: notificationItem.link,
                                 priority: notificationItem.priority,
                                 block: 0,
                                 completedAt: nil)
            items.append(item)
        }

        let sortedItems = items.sorted { (lhs: GuideItem, rhs: GuideItem) -> Bool in
            return lhs.priority > rhs.priority
        }

        items = List<GuideItem>(sortedItems)
    }
}

extension Guide: TwoWaySyncable {

    func setData(_ data: GuideIntermediary, objectStore: ObjectStore) throws {

    }

    func toJson() -> JSON? {
        let dict: [JsonKey: JSONEncodable] = [:]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

    static var endpoint: Endpoint {
        return .guidePlan
    }
}
