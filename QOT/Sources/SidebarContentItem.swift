//
//  SidebarContentItem.swift
//  QOT
//
//  Created by karmic on 16.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol SidebarContentItem: TrackableEntity {
    /// Whether the content has been viewed.
    var viewed: Bool { get }

    var title: String { get }

    var sidebarContentItemValue: ContentItemValue { get }
}

extension ContentItem: SidebarContentItem {

    var sidebarContentItemValue: ContentItemValue {
        do {
            return try getContentItemValue()
        } catch let error {
            fatalError("OMG \(error)")
        }
    }
}
