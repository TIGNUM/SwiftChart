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
        return mainRealm.syncableObject(ofType: ContentCategory.self, remoteID: id)
    }

    func contentCategories(ids: [Int]) -> AnyRealmCollection<ContentCategory> {
        return sortedResults(for: NSPredicate(remoteIDs: ids))
    }

    // MARK: - Collections

    func whatsHotArticles() -> AnyRealmCollection<ContentCollection> {
        return mainRealm.anyCollection(.sortOrder(), predicates: .section(.learnWhatsHot))
    }

    func contentCollections(ids: [Int]) -> AnyRealmCollection<ContentCollection> {
        return sortedResults(for: NSPredicate(remoteIDs: ids))
    }

    func contentCollections(categoryID: Int) -> AnyRealmCollection<ContentCollection> {
        return sortedResults(for: NSPredicate(format: "ANY categoryIDs.value == %d", categoryID))
    }

    func contentCollection(id: Int) -> ContentCollection? {
        return mainRealm.syncableObject(ofType: ContentCollection.self, remoteID: id)
    }

    func contentItems(contentCollectionID: Int) -> AnyRealmCollection<ContentItem> {
        return mainRealm.anyCollection(predicates: NSPredicate(format: "collectionID == %d", contentCollectionID))
    }

    func contentItemsOnBackground(contentCollectionID: Int) throws -> AnyRealmCollection<ContentItem> {
        return try realmProvider.realm().anyCollection(predicates: NSPredicate(format: "collectionID == %d", contentCollectionID))
    }

    func relatedArticles(for articleCollection: ContentCollection) -> [ContentCollection] {
        let predicate = NSPredicate(remoteIDs: articleCollection.relatedContentIDs)
        let results = mainRealm.objects(ContentCollection.self).sorted(by: [.sortOrder()]).filter(predicate)

        return Array(AnyRealmCollection<ContentCollection>(results))
    }

    func setViewed(localID: String) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    let contentItem = realm.syncableObject(ofType: ContentItem.self, localID: localID)
                    contentItem?.viewed = true
                }
            } catch let error {
                assertionFailure("UpdateViewedAt, itemId: \(localID), error: \(error)")
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

    static func sortOrder(ascending: Bool = false) -> SortDescriptor {
        return SortDescriptor(keyPath: Database.KeyPath.sortOrder.rawValue, ascending: ascending)
    }
}

private extension ContentService {

    func sortedResults<T>(for predicate: NSPredicate) -> AnyRealmCollection<T> {
        return mainRealm.anyCollection(.sortOrder(), predicates: predicate)
    }
}
