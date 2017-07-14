//
//  ContentService.swift
//  QOT
//
//  Created by Sam Wyndham on 24.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class ContentService {

    // MARK: - Properties

    fileprivate let mainRealm: Realm
    private let realmProvider: RealmProvider

    // MARK: - Init

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    // MARK: - Categories

    func articleCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .learnWhatsHot)
    }

    func libraryCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .library)
    }

    func learnContentCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .learnStrategy)
    }

    func learnContentCategoriesOnBackground() throws -> AnyRealmCollection<ContentCategory> {
        return try realmProvider.realm().contentCategories(section: .learnStrategy)
    }

    func contentCategory(id: Int) -> ContentCategory? {
        return mainRealm.anyCollection(primaryKey: id)
    }

    func contentCategories(ids: [Int]) -> AnyRealmCollection<ContentCategory> {
        return sortedResults(for: NSPredicate(remoteIDs: ids))
    }

    // MARK: - Collections

    func contentCollections(ids: [Int]) -> AnyRealmCollection<ContentCollection> {
        return sortedResults(for: NSPredicate(remoteIDs: ids))
    }

    func contentCollections(categoryID: Int) -> AnyRealmCollection<ContentCollection> {
        return sortedResults(for: NSPredicate(format: "ANY categoryIDs.value == %d", categoryID))
    }

    func contentCollection(id: Int) -> ContentCollection? {
        return mainRealm.anyCollection(primaryKey: id)
    }

    func contentItems(contentID: Int) -> AnyRealmCollection<ContentItem> {
        return mainRealm.anyCollection(predicates: NSPredicate(format: "collectionID == %d", contentID))
    }

    func contentItemsOnBackground(contentID: Int) throws -> AnyRealmCollection<ContentItem> {
        return try realmProvider.realm().anyCollection(predicates: NSPredicate(format: "collectionID == %d", contentID))
    }

    func setViewed(itemID: Int) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    let contentItem = realm.object(ofType: ContentItem.self, forPrimaryKey: itemID)
                    contentItem?.viewed = true
                }
            } catch let error {
                assertionFailure("UpdateViewedAt, itemId: \(itemID), error: \(error)")
            }
        }
    }
}

// MARK: - Private

private extension Realm {

    func contentCategories(section: Database.Section) -> AnyRealmCollection<ContentCategory> {
        let predicate = NSPredicate(format: "ANY contentCollections.section == %@", section.rawValue)
        return anyCollection(.sortOrder(), predicates: predicate)
    }
}

extension SortDescriptor {

    static func sortOrder(ascending: Bool = true) -> SortDescriptor {
        return SortDescriptor(keyPath: Database.KeyPath.sortOrder.rawValue, ascending: ascending)
    }
}

private extension ContentService {

    func sortedResults<T>(for predicate: NSPredicate) -> AnyRealmCollection<T> {
        return mainRealm.anyCollection(.sortOrder(), predicates: predicate)
    }
}
