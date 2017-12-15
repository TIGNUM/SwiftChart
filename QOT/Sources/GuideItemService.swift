//
//  GuideItemService.swift
//  QOT
//
//  Created by karmic on 15.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class GuideItemService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }
    
//    func createGuideItem(itemID: Int,
//                         title: String,
//                         body: String,
//                         type: String,
//                         typeDisplayString: String,
//                         greeting: String,
//                         link: String,
//                         priority: Int,
//                         block: Int,
//                         issueDate: Date?,
//                         displayTime: DateComponents,
//                         reminderTime: DateComponents,
//                         completedAt: Date?) throws -> GuideItem {
//        let realm = try self.realmProvider.realm()
//        let item = GuideItem(planItemID: itemID,
//                             title: title,
//                             body: body,
//                             type: type,
//                             typeDisplayString: typeDisplayString,
//                             greeting: greeting,
//                             link: link,
//                             priority: priority,
//                             block: block,
//                             issueDate: issueDate,
//                             displayTime: displayTime,
//                             reminderTime: reminderTime,
//                             completedAt: completedAt)
//
//        try realm.write {
//            realm.add(item)
//        }
//
//        return item
//    }

    func eraseGuideItems() {
        do {
            try mainRealm.write {
                mainRealm.delete(mainRealm.objects(GuideItem.self))
            }
        } catch {
            assertionFailure("Failed to delete toBeVision with error: \(error)")
        }
    }
}
