//
//  ContentService.swift
//  QOT
//
//  Created by Sam Wyndham on 24.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

extension NSPredicate {

    static func section(_ section: Database.Section) -> NSPredicate {
        return NSPredicate(section: section.value)
    }
}

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
        return contentCategories(section: .library)
    }

    func learnContentCategories() -> AnyRealmCollection<ContentCategory> {
        return contentCategories(section: .learnStrategy)
    }

    func contentCategory(id: Int) -> ContentCategory? {
        return mainRealm.anyCollection(primaryKey: id)
    }

    func contentCategories(section: Database.Section) -> AnyRealmCollection<ContentCategory> {
        let contentCollections: AnyRealmCollection<ContentCollection> = mainRealm.anyCollection(predicates: .section(section))
        let categoryIDs = Set(contentCollections.reduce([IntObject](), { $0.0 + $0.1.categoryIDs }).map { $0.value })
        return contentCategories(ids: Array(categoryIDs))
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

extension Realm {

    func anyCollection<T>(_ sort: SortDescriptor? = nil, predicates: NSPredicate...) -> AnyRealmCollection<T> {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        if let sort = sort {
            return AnyRealmCollection(objects(T.self).sorted(by: [sort]).filter(predicate))
        }

        return AnyRealmCollection(objects(T.self).filter(predicate))
    }

    func anyCollection<T, K>(primaryKey: K) -> T? where T : RealmSwift.Object {
        return object(ofType: T.self, forPrimaryKey: primaryKey)
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
