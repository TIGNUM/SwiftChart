//
//  Content.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

// FIXME: Unit test.
final class ContentCollection: Object, ContentCollectionDataProtocol {

    // MARK: SyncableRealmObject

    dynamic var remoteID: Int = 0

    dynamic var _syncStatus: Int8 = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    let categories: List<ContentCategory> = List()

    func setData(_ data: ContentCollectionDataProtocol) {
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
    }

    // MARK: ContentData

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var title: String = ""

    fileprivate(set) dynamic var layoutInfo: String?

    fileprivate(set) dynamic var searchTags: String = ""

    fileprivate(set) dynamic var relatedContent: String?

    // MARK: Realm

    override class func primaryKey() -> String? {
        return "remoteID"
    }

    // MARK: Relationships

    let items = LinkingObjects(fromType: ContentItem.self, property: "collection")
}

extension ContentCollection: DownSyncable {
    static func make(remoteID: Int, createdAt: Date) -> ContentCollection {
        let collection = ContentCollection()
        collection.remoteID = remoteID
        collection.createdAt = createdAt
        return collection
    }

    func setData(_ data: ContentCollectionData, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
        // FIXME: set Related Content
        let categoryPredicates = data.categoryIDs.map { NSPredicate(remoteID: $0) }
        let categories = try objectStore.uniqueObjects(ContentCategory.self, predicates: categoryPredicates )

        self.categories.removeAll()
        self.categories.append(objectsIn: categories)
    }
}
