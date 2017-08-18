//
//  ContentCategory+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 24.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

extension ContentCategory {

    var articleContent: AnyRealmCollection<ContentCollection> {
        return AnyRealmCollection(contentCollections)
    }

    var itemCount: Int {
        return contentCollections.count
    }

    var viewedCount: Int {
        return contentCollections.filter { $0.viewed }.count
    }

    var percentageLearned: Double {
        let total = contentCollections.reduce(0) { $0.0 + $0.1.percentageViewed }
        return total / Double(contentCollections.count)
    }

    var learnContent: AnyRealmCollection<ContentCollection> {
        return AnyRealmCollection(contentCollections)
    }

    var prepareContentCollection: AnyRealmCollection<ContentCollection> {
        return AnyRealmCollection(contentCollections)
    }

    var textColor: UIColor {
        return sidebarLayoutInfo.textColor
    }

    var cellHeight: CGFloat {
        return sidebarLayoutInfo.cellHeight
    }

    var font: UIFont {
        return sidebarLayoutInfo.font
    }

    var sidebarLayoutInfo: SidebarLayoutInfo {
        do {
            return try getSidebarLayoutInfo()
        } catch let error {
            fatalError("sidebarLayoutInfo \(error)")
        }
    }

    var sidebarContentCollection: AnyRealmCollection<ContentCollection> {
        return AnyRealmCollection(contentCollections)
    }
}
