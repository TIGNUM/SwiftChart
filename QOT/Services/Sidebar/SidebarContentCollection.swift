//
//  SidebarContentCollection.swift
//  QOT
//
//  Created by karmic on 16.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

/// Encapsulates data to display in a `LearnContentListViewController`.
protocol SidebarContentCollection: TrackableEntity {
    /// The title of the content.
    var title: String { get }
    /// Whether the content has been viewed.
    var viewed: Bool { get }
    /// Time required in minutes to view the content.
    var minutesRequired: Int { get }

    var sidebarContentItems: DataProvider<SidebarContentItem> { get }
}

extension ContentCollection: SidebarContentCollection {

    var sidebarContentItems: DataProvider<SidebarContentItem> {
        return DataProvider(list: items, map: { $0 as SidebarContentItem })
    }
}
