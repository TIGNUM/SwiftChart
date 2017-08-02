//
//  PageTrackValue.swift
//  QOT
//
//  Created by Sam Wyndham on 14.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class PageTrackAssociatedObject: Object {

    private enum ObjectType: String {
        case CONTENTCATEGORY
        case CONTENT
        case CONTENTITEM
    }

    private dynamic var contentCategory: ContentCategory?

    private dynamic var contentCollection: ContentCollection?

    private dynamic var contentItem: ContentItem?

    convenience init(object: AnyObject) {
        self.init()

        if let value = object as? ContentCategory {
            contentCategory = value
        } else if let value = object as? ContentCollection {
            contentCollection = value
        } else if let value = object as? ContentItem {
            contentItem = value
        } else {
            fatalError("Unsupported Object: \(object)")
        }
    }

    var values: (type: String, id: Int)? {
        if let value = contentCategory {
            return values(type: .CONTENTCATEGORY, id: value.forcedRemoteID)
        } else if let value = contentCollection {
            return values(type: .CONTENT, id: value.forcedRemoteID)
        } else if let value = contentItem {
            return values(type: .CONTENTITEM, id: value.forcedRemoteID)
        } else {
            return nil
        }
    }

    // MARK: Private

    private func values(type: ObjectType, id: Int) -> (type: String, id: Int) {
        return (type: type.rawValue, id: id)
    }
}
