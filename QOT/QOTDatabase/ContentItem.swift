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
        try data.validate()

        sortOrder = data.sortOrder
        title = data.title
        secondsRequired = data.secondsRequired
        value = data.value
        format = data.format
        viewAt = data.viewAt
        searchTags = data.searchTags
        layoutInfo = data.layoutInfo
    }

    // MARK: ContentData

    private(set) dynamic var sortOrder: Int = 0

    private(set) dynamic var title: String = ""

    private(set) dynamic var secondsRequired: Int = 0

    private(set) dynamic var value: String = ""

    private(set) dynamic var format: Int8 = 0

    private(set) dynamic var searchTags: String = ""

    private(set) dynamic var layoutInfo: String?

    dynamic var viewAt: Date?

    // MARK: Realm

    override class func primaryKey() -> String? {
        return "remoteID"
    }
}

extension ContentItem {

    func getContentItemValue() throws -> ContentItemValue {
        guard let format = ContentItemFormat(rawValue: format) else {
            throw InvalidDataError(data: self)
        }

        return try ContentItemValue(format: format, value: value)
    }

    func accordionTitle() -> String? {
        guard let jsonString = layoutInfo, let json = try? JSON(jsonString: jsonString) else {
            return nil
        }

        return try? json.getString(at: "accordionTitle")
    }
}
