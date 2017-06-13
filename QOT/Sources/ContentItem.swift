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
final class ContentItem: Object, ContentItemDataProtocol {

    // MARK: SyncableRealmObject

    dynamic var remoteID: Int = 0

    dynamic var _syncStatus: Int8 = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    dynamic var collection: ContentCollection?

    func setData(_ data: ContentItemDataProtocol) throws {
        sortOrder = data.sortOrder
        secondsRequired = data.secondsRequired
        value = data.value
        format = data.format
        viewed = data.viewed
        searchTags = data.searchTags
        layoutInfo = data.layoutInfo
        tabs = data.tabs
    }

    // MARK: ContentData

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var secondsRequired: Int = 0

    fileprivate(set) dynamic var value: String = ""

    fileprivate(set) dynamic var format: String = ""

    fileprivate(set) dynamic var searchTags: String = ""

    fileprivate(set) dynamic var tabs: String = ""

    fileprivate(set) dynamic var layoutInfo: String?

    fileprivate(set) dynamic var contentID: Int = 0

    dynamic var viewed: Bool = false

    // MARK: Realm

    override class func primaryKey() -> String? {
        return "remoteID"
    }
}

extension ContentItem: DownSyncable {
    static func make(remoteID: Int, createdAt: Date) -> ContentItem {
        let item = ContentItem()
        item.remoteID = remoteID
        item.createdAt = createdAt
        return item
    }

    func setData(_ data: ContentItemData, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        secondsRequired = data.secondsRequired
        value = data.value
        format = data.format
        viewed = data.viewed
        searchTags = data.searchTags
        tabs = data.tabs
        layoutInfo = data.layoutInfo
        collection = try objectStore.uniqueObject(ContentCollection.self, predicate: NSPredicate(remoteID: data.contentID))
    }
}

extension ContentItem {

    var contentItemValue: ContentItemValue {
        guard
            let format = ContentItemFormat(rawValue: format),
            let value = try? ContentItemValue(format: format, value: value)
        else {
            return .invalid
        }

        return value
    }

    func accordionTitle() -> String? {
        guard let jsonString = layoutInfo, let json = try? JSON(jsonString: jsonString) else {
            return nil
        }

        return try? json.getString(at: "accordionTitle")
    }
}
