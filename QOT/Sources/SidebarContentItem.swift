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

    var contentItemValue: ContentItemValue { get }
}

extension ContentItem: SidebarContentItem {}
