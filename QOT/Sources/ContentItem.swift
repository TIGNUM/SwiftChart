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

    func setData(_ data: ContentItemIntermediary) throws {
        sortOrder = data.sortOrder
        format = data.format
        viewed = data.viewed
        searchTags = data.searchTags
        layoutInfo = data.layoutInfo
        tabs = data.tabs
        valueText = data.valueText
        valueDescription = data.valueDescription
        valueImageURL = data.valueImageURL
        valueMediaURL = data.valueMediaURL
        valueDuration.value = data.valueDuration
        valueWavformData = data.valueWavformData
    }

    // MARK: ContentData

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var format: String = ""

    fileprivate(set) dynamic var searchTags: String = ""

    fileprivate(set) dynamic var tabs: String = ""

    fileprivate(set) dynamic var layoutInfo: String?

    fileprivate(set) dynamic var valueText: String?

    fileprivate(set) dynamic var valueDescription: String?

    fileprivate(set) dynamic var valueImageURL: String?

    fileprivate(set) dynamic var valueMediaURL: String?

    let valueDuration = RealmOptional<Double>(nil)

    fileprivate(set) dynamic var valueWavformData: String?

    dynamic var viewed: Bool = false

    let relatedContent: List<ContentRelation> = List()

    var secondsRequired: Int {
        return Int(valueDuration.value ?? 0.0)
    }
    
    // MARK: Relationships

    fileprivate(set) dynamic var contentCollection: ContentCollection?

    func buildRelations(realm: Realm) {
        if let id = collectionID.value {
            contentCollection = realm.syncableObject(ofType: ContentCollection.self, remoteID: id)
        }
    }
}

extension ContentItem: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .contentItems
    }

    func setData(_ data: ContentItemIntermediary, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        format = data.format
        viewed = data.viewed
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

        objectStore.delete(relatedContent)
        relatedContent.append(objectsIn: data.relatedContent.map({ ContentRelation(intermediary: $0) }))
    }
}
