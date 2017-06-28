//
//  SidebarItemViewModel.swift
//  QOT
//
//  Created by karmic on 28.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class SidebarItemViewModel {

    // MARK: - Properties

    fileprivate let contentCollections: [ContentCollection]
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        guard contentCollections.isEmpty == false else {
            return 0
        }

        return contentCollections[0].items.count
    }

    func sidebarContentItems(at indexPath: IndexPath) -> ContentItem {
        return contentCollections[0].items[indexPath.row]
    }

    // MARK: - Init

    init(contentCollections: [ContentCollection]) {
        self.contentCollections = contentCollections
    }
}
