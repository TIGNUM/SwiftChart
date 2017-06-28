//
//  Content.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift
import Freddy

// FIXME: Unit test.
final class ContentCollection: Object {

    // MARK: SyncableRealmObject

    dynamic var remoteID: Int = 0

    dynamic var _syncStatus: Int8 = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    let categoryIDs: List<IntObject> = List()

    func setData(_ data: ContentCollectionData) {
        section = data.section
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
        thumbnailURLString = data.thumbnailURLString
    }

    // MARK: ContentData

    fileprivate(set) dynamic var section: String = ""

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var title: String = ""

    fileprivate(set) dynamic var layoutInfo: String?

    fileprivate(set) dynamic var searchTags: String = ""

    fileprivate(set) dynamic var relatedContent: String?

    fileprivate(set) dynamic var thumbnailURLString: String?

    // MARK: Realm

    override class func primaryKey() -> String? {
        return "remoteID"
    }

    // MARK: Relationships

    lazy var items: Results<ContentItem> = {
        guard let realm = self.realm else {
            preconditionFailure("Attempted to access items on an unmanaged ContentCollection: \(self)")
        }

        let predicate = NSPredicate(format: "collectionID == %d", self.remoteID)
        return realm.objects(ContentItem.self).filter(predicate)
    }()

    // MARK: Computed Properties

    var relatedContentIDs: [Int] {
        guard
            let relatedContent = relatedContent,
            let json = try? JSON(jsonString: relatedContent),
            let ids = try? json.decodedArray(type: Int.self)
            else {
                return []
        }
        return ids
    }
}

extension ContentCollection: DownSyncable {

    static func make(remoteID: Int, createdAt: Date) -> ContentCollection {
        let collection = ContentCollection()
        collection.remoteID = remoteID
        collection.createdAt = createdAt
        return collection
    }

    func setData(_ data: ContentCollectionData, objectStore: ObjectStore) throws {
        section = data.section
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
        thumbnailURLString = data.thumbnailURLString
        relatedContent = data.relatedContentIDs

        objectStore.delete(categoryIDs)
        categoryIDs.append(objectsIn: data.categoryIDs.map({ IntObject(int: $0) }))
    }
}
