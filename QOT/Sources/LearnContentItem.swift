//
//  LearnContentItem.swift
//  QOT
//
//  Created by karmic on 04.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol LearnContentItem: TrackableEntity {
    /// Whether the content has been viewed.
    var viewed: Bool { get }

    var contentItemValue: ContentItemValue { get }

    var format: String { get }

    var contentItemTextStyle: ContentItemTextStyle { get }

    var remoteID: Int { get }

}

extension ContentItem: LearnContentItem {

    var contentItemTextStyle: ContentItemTextStyle {
        guard
            let contentItemFormat = ContentItemFormat(rawValue: format),
            let contentItemTextStyle = ContentItemTextStyle.createStyle(for: contentItemFormat) else {
                fatalError("ContentItemFormat is not valid or nil.")
        }

        return contentItemTextStyle
    }

    var trackableEntityID: Int {
        return Int.randomID
    }

    var remoteIdentifier: Int {
        return remoteID
    }
}
