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

    var title: String { get }

    var contentItemValue: ContentItemValue { get }
}

extension ContentItem: LearnContentItem {

    var contentItemValue: ContentItemValue {
        do {
            return try getContentItemValue()
        } catch let error {
            fatalError("That should not happen ;) [Error while parsing contentItemValue] \(error)")
        }
    }

    var trackableEntityID: Int {
        return Int.randomID
    }

    var remoteIdentifier: Int {
        return remoteID
    }
}
