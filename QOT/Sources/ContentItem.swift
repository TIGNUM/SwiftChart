//
//  ContentItem.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

// FIXME: Unit test.
final class ContentItem: SyncableObject {

    let collectionID = RealmOptional<Int>(nil)

    @objc private(set) dynamic var sortOrder: Int = 0

    @objc private(set) dynamic var format: String = ""

    @objc private(set) dynamic var searchTags: String = ""

    @objc private(set) dynamic var tabs: String = ""

    @objc private(set) dynamic var layoutInfo: String?

    @objc private(set) dynamic var valueText: String?

    @objc private(set) dynamic var valueDescription: String?

    @objc private(set) dynamic var valueImageURL: String?

    @objc private(set) dynamic var valueMediaURL: String?

    let valueMediaID = RealmOptional<Int>(nil)

    let valueDuration = RealmOptional<Double>(nil)

    @objc private(set) dynamic var valueWavformData: String?

    let relatedContent: List<ContentRelation> = List()

    var secondsRequired: Int {
        return Int(valueDuration.value ?? 0.0)
    }

    // MARK: Relationships

    @objc private(set) dynamic var contentCollection: ContentCollection?
}

// MARK: - BuildRelations

extension ContentItem: BuildRelations {

    func buildRelations(realm: Realm) {
        if let id = collectionID.value {
            contentCollection = realm.syncableObject(ofType: ContentCollection.self, remoteID: id)
        }
    }
}

// MARK: - OneWaySyncableDown

extension ContentItem: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .contentItems
    }

    func setData(_ data: ContentItemIntermediary, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        format = data.format
        searchTags = data.searchTags
        tabs = data.tabs
        layoutInfo = data.layoutInfo
        collectionID.value = data.contentID
        valueText = data.valueText
        valueDescription = data.valueDescription
        valueImageURL = data.valueImageURL
        valueMediaURL = data.valueMediaURL
        valueDuration.value = data.valueDuration
        valueWavformData = data.valueWavformData
        valueMediaID.value = data.valueMediaID

        objectStore.delete(relatedContent)
        relatedContent.append(objectsIn: data.relatedContent.map({ ContentRelation(intermediary: $0) }))
    }
}
