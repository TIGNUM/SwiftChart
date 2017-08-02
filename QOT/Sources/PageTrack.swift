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

    fileprivate dynamic var pageID: Int = 0

    fileprivate let referrerPageID: RealmOptional<Int> = RealmOptional(nil)

    fileprivate dynamic var associatedObject: PageTrackAssociatedObject?

    fileprivate dynamic var referrerAssociatedObject: PageTrackAssociatedObject?

    convenience init(pageID: Int, referrerPageID: Int?, associatedObject: AnyObject?, referrerAssociatedObject: AnyObject?) {
        self.init()

        self.pageID = pageID
        self.referrerPageID.value = referrerPageID
        self.associatedObject = associatedObject.map { PageTrackAssociatedObject(object: $0) }
        self.referrerAssociatedObject = referrerAssociatedObject.map { PageTrackAssociatedObject(object: $0) }
    }
}

extension PageTrack: JSONEncodable {

    func toJSON() -> JSON {
        guard readyToUpload else {
            return .null
        }

        let dateFormatter = DateFormatter.iso8601
        let dict: [JsonKey: JSON] = [
            .createdAt: .string(dateFormatter.string(from: createdAt)),
            .pageId: .int(pageID),
            .referrerPageId: JSON.make(with: referrerPageID.value),
            .associatedValueId: JSON.make(with: associatedObject?.values?.id),
            .associatedValueType: JSON.make(with: associatedObject?.values?.type),
            .referrerAssociatedValueId: JSON.make(with: referrerAssociatedObject?.values?.id),
            .referrerAssociatedValueType: JSON.make(with: referrerAssociatedObject?.values?.type)
        ]

        return .dictionary(dict.mapKeys({ $0.rawValue }))
    }

    // MARK: Private

    private var readyToUpload: Bool {
        if let associatedObject = associatedObject, associatedObject.values == nil {
            return false
        }
        if let referrerAssociatedObject = referrerAssociatedObject, referrerAssociatedObject.values == nil {
            return false
        }
        return true
    }
}

// MARK: Private helpers

private extension JSON {

    static func make(with value: String?) -> JSON {
        return value.map { .string($0) } ?? .null
    }

    static func make(with value: Int?) -> JSON {
        return value.map { .int($0) } ?? .null
    }
}
