//
//  ContentItem.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

// FIXME: Unit test.
public final class ContentItem: Object, SyncableRealmObject, ContentItemData {

    // MARK: Private Properties

    private dynamic var _value: String = ""
    private dynamic var _format: Int8 = 0
    private dynamic var _status: Int8 = 0

    // MARK: SyncableRealmObject

    public let _remoteID: RealmOptional<Int> = RealmOptional()

    public dynamic var _syncStatus: Int8 = 0

    public private(set) dynamic var localID: String = UUID().uuidString

    public dynamic var modifiedAt: Date = Date()

    public dynamic var parent: Content?

    public func setData(_ data: ContentItemData) {
        sortOrder = data.sortOrder
        title = data.title
        secondsRequired = data.secondsRequired
        value = data.value
        status = data.status
    }

    // MARK: ContentData

    public dynamic var sortOrder: Int = 0

    public dynamic var title: String = ""

    public dynamic var secondsRequired: Int = 0

    public var value: ContentItemValue {
        get {
            do {
                return try ContentItemValue(format: _format, value: _value)
            } catch let error {
                fatalError("Failed to get content item data: \(error)")
            }
        }
        set {
            _format = newValue.format
            _value = newValue.value
        }
    }

    public var status: ContentItemStatus {
        get {
            guard let status = ContentItemStatus(rawValue: _status) else {
                fatalError("Invalid content item status: \(_status)")
            }
            return status
        }
        set {
            _status = newValue.rawValue
        }
    }

    // MARK: Realm

    override public class func primaryKey() -> String? {
        return "localID"
    }

    override public static func indexedProperties() -> [String] {
        return ["_remoteID"]
    }
}




