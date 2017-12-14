//
//  GuideItemLearnService.swift
//  QOT
//
//  Created by karmic on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class GuideItemLearnService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func nextItems() -> List<GuideItemLearn> {
        let allItems = mainRealm.objects(GuideItemLearn.self)
        let todoItems = allItems.filter { $0.completed == false }
        let minBlock = todoItems.map { $0.block }.min() ?? 1
        let filteredResults = allItems.filter { $0.block == minBlock }

        return List<GuideItemLearn>(filteredResults)
    }

    func setItemCompleted(item: GuideItemLearn) {
        do {
            try mainRealm.write {
                item.completed = true
            }
        } catch let error {
            assertionFailure("Set item completed: \(GuideItemLearn.self), error: \(error)")
        }
    }

    func eraseItem(item: GuideItemLearn) {
        do {
            try mainRealm.write {
                mainRealm.delete(item)
            }
        } catch {
            assertionFailure("Failed to delete GuidePlanItemLearn with error: \(error)")
        }
    }
}

private extension Realm {

    func guidePlanItemsLearn(day: Int, type: GuideItemLearn.GuidePlanItemType) -> AnyRealmCollection<GuideItemLearn> {
        let predicate = NSPredicate(format: "ANY type == %@ AND day == %d", type.rawValue, day)
        return anyCollection(.priorityOrder(), predicates: predicate)
    }
}

extension SortDescriptor {

    static func priorityOrder(ascending: Bool = false) -> SortDescriptor {
        return SortDescriptor(keyPath: Database.KeyPath.priority.rawValue, ascending: ascending)
    }
}
