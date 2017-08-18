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
        return percentageViewed > 0
    }

    var minutesRequired: Int {
        return items.reduce(0, { $0.0 + $0.1.secondsRequired }) / 60
    }

    var percentageViewed: Double {
        let viewed = items.filter { $0.viewed != false }
        return Double(viewed.count) / Double(items.count)
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
