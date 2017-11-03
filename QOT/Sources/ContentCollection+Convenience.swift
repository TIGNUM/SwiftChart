//
//  ContentCollection+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 24.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

extension ContentCollection {

    var thumbnailURL: URL? {
        return thumbnailURLString.flatMap { URL(string: $0) }
    }

    var articleItems: AnyRealmCollection<ContentItem> {
        return AnyRealmCollection(items)
    }

    var viewed: Bool {
        return viewedAt != nil
    }

    var minutesToRead: Int {
        return items.reduce(0, { (sum, item) -> Int in
            if let format = ContentItemFormat(rawValue: item.format) {
                switch format {
                case .video, .audio, .image, .pdf:
                    return sum
                default:
                    return sum + item.secondsRequired
                }
            }
            return sum
        }) / 60
    }

    var contentItems: AnyRealmCollection<ContentItem> {
        return AnyRealmCollection(items)
    }

    var selected: Bool {
        return viewed
    }

    var prepareItems: AnyRealmCollection<ContentItem> {
        return AnyRealmCollection(items)
    }

    var sidebarContentItems: AnyRealmCollection<ContentItem> {
        return AnyRealmCollection(items)
    }

    var editedAt: Date {
        return self.modifiedAt
    }
}
