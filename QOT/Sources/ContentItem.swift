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
final class ContentItem: Object {

    // MARK: SyncableRealmObject

    dynamic var remoteID: Int = 0

    dynamic var _syncStatus: Int8 = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    let collectionID = RealmOptional<Int>(nil)

    func setData(_ data: ContentItemIntermediary) throws {
        sortOrder = data.sortOrder
        secondsRequired = data.secondsRequired
        format = data.format
        viewed = data.viewed
        searchTags = data.searchTags
        layoutInfo = data.layoutInfo
        tabs = data.tabs
        value = data.value
        valueText = data.valueText
        valueDescription = data.valueDescription
        valueImageURL = data.valueImageURL
        valueMediaURL = data.valueMediaURL
        valueDuration.value = data.valueDuration
        valueWavformData = data.valueWavformData
    }

    // MARK: ContentData

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var secondsRequired: Int = 0

    fileprivate(set) dynamic var format: String = ""

    fileprivate(set) dynamic var searchTags: String = ""

    fileprivate(set) dynamic var tabs: String = ""

    fileprivate(set) dynamic var layoutInfo: String?

    fileprivate(set) dynamic var contentID: Int = 0

    fileprivate(set) dynamic var value: String?

    fileprivate(set) dynamic var valueText: String?

    fileprivate(set) dynamic var valueDescription: String?

    fileprivate(set) dynamic var valueImageURL: String?

    fileprivate(set) dynamic var valueMediaURL: String?

    let valueDuration = RealmOptional<Double>(nil)

    fileprivate(set) dynamic var valueWavformData: String?

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

    func setData(_ data: ContentItemIntermediary, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        secondsRequired = data.secondsRequired
        format = data.format
        viewed = data.viewed
        searchTags = data.searchTags
        tabs = data.tabs
        layoutInfo = data.layoutInfo
        collectionID.value = data.contentID
        value = data.value
        valueText = data.valueText
        valueDescription = data.valueDescription
        valueImageURL = data.valueImageURL
        valueMediaURL = data.valueMediaURL
        valueDuration.value = data.valueDuration
        valueWavformData = data.valueWavformData
    }
}

extension ContentItem {

    var contentItemValue: ContentItemValue {
        // FIXME: Remove once not needed for mock data
        if let jsonValue = value {
            guard
                let format = ContentItemFormat(rawValue: format),
                let value = try? ContentItemValue(format: format, value: jsonValue)
                else {
                    return .invalid
            }
            return value
        }

        return ContentItemValue(item: self)
    }

    func accordionTitle() -> String? {
        guard let jsonString = layoutInfo, let json = try? JSON(jsonString: jsonString) else {
            return nil
        }

        return try? json.getString(at: "accordionTitle")
    }
}
