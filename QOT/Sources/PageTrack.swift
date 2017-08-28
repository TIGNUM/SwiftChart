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
    
    fileprivate dynamic var associatedValueLocalID: String?
    
    fileprivate dynamic var associatedValueType: String?

    fileprivate dynamic var referrerAssociatedValueLocalID: String?
    
    fileprivate dynamic var referrerAssociatedValueType: String?
    
    convenience init(page: Page, referrerPage: Page?, associatedValueLocalID: String?, associatedValueType: String?, referrerAssociatedValueLocalID: String?, referrerAssociatedValueType: String?) {
        self.init()

        self.page = page
        self.referrerPage = referrerPage
        self.associatedValueLocalID = associatedValueLocalID
        self.associatedValueType = associatedValueType
        self.referrerAssociatedValueLocalID = referrerAssociatedValueLocalID
        self.referrerAssociatedValueType = referrerAssociatedValueType
    }
    
    // MARK: - private
    
    // FIXME: refactor when Realm issue is resolved https://github.com/realm/realm-cocoa/issues/1109#issuecomment-143834756
    fileprivate func syncableObject(forIdentifier identifier: PageObject.Identifier, localID: String) -> SyncableObject? {
        switch identifier {
        case .category:
            return realm?.syncableObject(ofType: ContentCategory.self, localID: localID)
        case .contentItem:
            return realm?.syncableObject(ofType: ContentItem.self, localID: localID)
        case .contentCollection:
            return realm?.syncableObject(ofType: ContentCollection.self, localID: localID)
        case .myToBeVision:
            return realm?.syncableObject(ofType: MyToBeVision.self, localID: localID)
        case .preparation:
            return realm?.syncableObject(ofType: Preparation.self, localID: localID)
        }
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
            let pageID = page?.remoteID.value else {
            return nil
        }
        var associatedValue: SyncableObject?
        if
            let associatedValueType = associatedValueType,
            let associatedValueLocalID = associatedValueLocalID,
            let identifier = PageObject.Identifier(rawValue: associatedValueType) {
            associatedValue = syncableObject(forIdentifier: identifier, localID: associatedValueLocalID)
            if associatedValue?.remoteID == nil {
                return nil
            }
        }
        var referrerAssociatedValue: SyncableObject?
        if
            let referrerAssociatedValueType = referrerAssociatedValueType,
            let referrerAssociatedValueLocalID = referrerAssociatedValueLocalID,
            let identifier = PageObject.Identifier(rawValue: referrerAssociatedValueType) {
            referrerAssociatedValue = syncableObject(forIdentifier: identifier, localID: referrerAssociatedValueLocalID)
            if referrerAssociatedValue?.remoteID == nil {
                return nil
            }
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
