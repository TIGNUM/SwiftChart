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

    func items() -> List<GuideItemLearn> {
        let items = nextStrategyItems()
        items.append(objectsIn: nextFeatureItems())

        return List<GuideItemLearn>(items)
    }

    func setItemCompleted(item: GuideItemLearn) {
        do {
            try mainRealm.write {
                item.completedAt = Date()
            }
        } catch {
            assertionFailure("Set item completed: \(GuideItemLearn.self), error: \(error)")
        }
    }

    func eraseItem(item: GuideItemLearn) {
        do {
            try mainRealm.write {
                mainRealm.delete(item)
            }
        } catch {
            assertionFailure("Failed to delete GuideItemLearn with error: \(error)")
        }
    }

    func eraseItems() {
        do {
            try mainRealm.write {
                mainRealm.delete(mainRealm.objects(GuideItemLearn.self))
            }
        } catch {
            assertionFailure("Failed to delete GuideItemsLearn with error: \(error)")
        }
    }
}

private extension GuideItemLearnService {

    func nextStrategyItems() -> List<GuideItemLearn> {
        return List<GuideItemLearn>(nextMinBlockItems(nextItems(.strategy)))
    }

    func nextFeatureItems() -> List<GuideItemLearn> {
        return List<GuideItemLearn>(nextMinBlockItems(nextItems(.feature)))
    }

    func nextMinBlockItems(_ items: [GuideItemLearn]) -> [GuideItemLearn] {
        let minBlock = items.map { $0.block }.min() ?? 1

        return items.filter { $0.block == minBlock }
    }

    func nextItems(_ type: GuideItemLearn.ItemType) -> [GuideItemLearn] {
        let items = mainRealm.objects(GuideItemLearn.self)
        let nextItems = items.filter { $0.completedAt == nil }

        return nextItems.filter { $0.type == type.rawValue }
    }
}

private extension Realm {

    func guidePlanItemsLearn(day: Int, type: GuideItemLearn.ItemType) -> AnyRealmCollection<GuideItemLearn> {
        let predicate = NSPredicate(format: "ANY type == %@ AND day == %d", type.rawValue, day)
        return anyCollection(.priorityOrder(), predicates: predicate)
    }
}

extension SortDescriptor {

    static func priorityOrder(ascending: Bool = false) -> SortDescriptor {
        return SortDescriptor(keyPath: Database.KeyPath.priority.rawValue, ascending: ascending)
    }
}
