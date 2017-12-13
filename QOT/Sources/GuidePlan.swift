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

extension GuidePlan {

    struct PlanItem {
        var title: String?
        var body: String
        var type: String
        var greeting: String?
        var link: String
        var priority: Int
        var status: GuideViewModel.Status
    }
}

final class GuidePlan: SyncableObject {

    @objc dynamic var planID: String = ""

    @objc dynamic var greeting: String = ""

    @objc dynamic var planingTime: String  = ""

    @objc dynamic var planDay: String = ""

    @objc dynamic var deleted: Bool = false

    var learnItems = List<GuidePlanItemLearn>()

    var notificationItems = List<GuidePlanItemNotification>()

    var planItems = [GuidePlan.PlanItem]()

    @objc dynamic var changeStamp: String? = UUID().uuidString

    convenience init(learnItems: List<GuidePlanItemLearn>,
                     notificationItems: List<GuidePlanItemNotification>) {
        self.init()

        self.learnItems = learnItems
        self.notificationItems = notificationItems        
    }

    func cratePlanItems() {
        learnItems.forEach { (learnItem: GuidePlanItemLearn) in
            let planItem = GuidePlan.PlanItem(title: learnItem.title,
                                              body: learnItem.body,
                                              type: learnItem.body,
                                              greeting: learnItem.greeting,
                                              link: learnItem.link,
                                              priority: learnItem.priority,
                                              status: learnItem.completed == true ? .done : .todo)
            planItems.append(planItem)
        }

        notificationItems.forEach { (notificationItem: GuidePlanItemNotification) in
            let planItem = GuidePlan.PlanItem(title: notificationItem.title,
                                              body: notificationItem.body,
                                              type: notificationItem.type,
                                              greeting: notificationItem.greeting,
                                              link: notificationItem.link,
                                              priority: notificationItem.priority,
                                              status: notificationItem.completed == true ? .done : .todo)
            planItems.append(planItem)
        }

        planItems.sort { (lhs: GuidePlan.PlanItem, rhs: GuidePlan.PlanItem) -> Bool in
            return lhs.priority > rhs.priority
        }
    }
}

extension GuidePlan: TwoWaySyncable {

    func setData(_ data: GuidePlanIntermediary, objectStore: ObjectStore) throws {

    }

    func toJson() -> JSON? {
        let dict: [JsonKey: JSONEncodable] = [:]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }

    static var endpoint: Endpoint {
        return .guidePlan
    }
}
