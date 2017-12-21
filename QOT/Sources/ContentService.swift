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

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    // MARK: - Init

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    // MARK: - Categories

    func eraseData() {
        do {
            try mainRealm.write {
                mainRealm.delete(libraryCategories())
                mainRealm.delete(learnContentCategories())
                mainRealm.delete(whatsHotArticles())
                mainRealm.delete(tools())
            }
        } catch {
            assertionFailure("Failed to delete content with error: \(error)")
        }
    }

    func libraryCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .library)
    }

    func toolsCategories() -> AnyRealmCollection<ContentCategory> {
        let library = Database.Section.library.rawValue
        let predicate = NSPredicate(format: "ANY contentCollections.section == %@ AND remoteID != %d", library, 100037)

        return sortedResults(for: predicate)
    }

    func learnContentCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .learnStrategy)
    }

    func learnContentCategory(categoryTitle: String) -> ContentCategory? {
        return learnContentCategories().filter(NSPredicate(format: "title == %@", categoryTitle)).first
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

    func tools() -> AnyRealmCollection<ContentCollection> {
        return mainRealm.anyCollection(.sortOrder(), predicates: .section(.tools))
    }

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

    func defaultMessage(_ itemID: Int) -> String {
        let welcomeMessageCollection = contentCollection(id: 100708)
        let predicate = NSPredicate(remoteID: itemID)
        return welcomeMessageCollection?.contentItems.filter(predicate).flatMap { $0.valueText }.first ?? ""
    }

    func relatedArticles(for articleCollection: ContentCollection) -> [ContentCollection] {
        let predicate = NSPredicate(remoteIDs: articleCollection.relatedContentIDs)
        let results = mainRealm.objects(ContentCollection.self).sorted(by: [.sortOrder()]).filter(predicate)

        return Array(AnyRealmCollection<ContentCollection>(results))
    }

    func setContentCollectionViewed(localID: String) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    if let contentCollection = realm.syncableObject(ofType: ContentCollection.self, localID: localID) {
                        if let contentRead = contentCollection.contentRead {
                            contentRead.viewedAt = Date()
                        } else {
                            contentCollection.contentRead = ContentRead(contentCollection: contentCollection)
                        }
                    }
                }
            } catch let error {
                assertionFailure("UpdateViewedAt, contentId: \(localID), error: \(error)")
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
