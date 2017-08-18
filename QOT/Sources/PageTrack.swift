//
//  PageTrack.swift
//  QOT
//
//  Created by Sam Wyndham on 14.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class PageTrack: SyncableObject {

    fileprivate dynamic var page: Page?
    
    fileprivate dynamic var referrerPage: Page?
    
    fileprivate dynamic var associatedValue: SyncableObject?
    
    fileprivate dynamic var associatedValueType: String?
    
    fileprivate dynamic var referrerAssociatedValue: SyncableObject?
    
    fileprivate dynamic var referrerAssociatedValueType: String?

    convenience init(page: Page, referrerPage: Page?, associatedValue: SyncableObject?, associatedValueType: String?, referrerAssociatedValue: SyncableObject?, referrerAssociatedValueType: String?) {
        self.init()

        self.page = page
        self.referrerPage = referrerPage
        self.associatedValue = associatedValue
        self.associatedValueType = associatedValueType
        self.referrerAssociatedValue = referrerAssociatedValue
        self.referrerAssociatedValueType = referrerAssociatedValueType
    }
}

// MARK: - OneWaySyncable

extension PageTrack: OneWaySyncableUp {
    
    static var endpoint: Endpoint {
        return .pageTracking
    }
    
    func toJson() -> JSON? {
        guard
            syncStatus != .clean,
            let pageID = page?.remoteID.value,
            (associatedValue == nil || associatedValue?.remoteID != nil),
            (referrerAssociatedValue == nil || referrerAssociatedValue?.remoteID != nil) else {
            return nil
        }
        let referrerPageID = referrerPage?.remoteID.value
        let associatedValueID = associatedValue?.remoteID.value
        let referrerAssociatedValueID = referrerAssociatedValue?.remoteID.value
        let dateFormatter = DateFormatter.iso8601
        let dict: [JsonKey: JSONEncodable] = [
            .createdAt: dateFormatter.string(from: createdAt),
            .pageId: pageID,
            .referrerPageId: (referrerPageID ?? nil).toJSONEncodable,
            .associatedValueId: (associatedValueID ?? nil).toJSONEncodable,
            .associatedValueType: associatedValueType.toJSONEncodable,
            .referrerAssociatedValueId: (referrerAssociatedValueID ?? nil).toJSONEncodable,
            .referrerAssociatedValueType: referrerAssociatedValueType.toJSONEncodable
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
