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
final class ContentCollection: SyncableObject {

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

    // MARK: Relationships

    let items = List<ContentItem>()

    let contentCategories = List<ContentCategory>()

    func buildRelations(realm: Realm) {
        let categoryIDs = Array(self.categoryIDs.map({ $0.value }))
        let categories = realm.syncableObjects(ofType: ContentCategory.self, remoteIDs: categoryIDs)
        contentCategories.removeAll()
        contentCategories.append(objectsIn: categories)
    }

    func buildInverseRelations(realm: Realm) {
        let predicate = NSPredicate(format: "contentCollection == %@", self)
        let items = realm.objects(ContentItem.self).filter(predicate)
        self.items.removeAll()
        self.items.append(objectsIn: items)
    }

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

extension ContentCollection: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .contentCollection
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
