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

    fileprivate let sidebarContentCategory: SidebarContentCategory
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return sidebarContentCategory.sidebarContentCollection.item(at: 0).sidebarContentItems.count
    }

    func sidebarContentItems(at indexPath: IndexPath) -> SidebarContentItem {
        return sidebarContentCategory.sidebarContentCollection.item(at: indexPath.section).sidebarContentItems.item(at: indexPath.row)
    }

    // MARK: - Init

    init(sidebarContentCategory: SidebarContentCategory) {
        self.sidebarContentCategory = sidebarContentCategory
    }
}

enum SidebarItem {
    case text(localID: String, title: NSAttributedString, text: NSAttributedString)
    case video(localID: String, placeholderURL: URL, description: NSAttributedString?)
    case audio(localID: String, placeholderURL: URL, description: NSAttributedString?)
    case image(localID: String, placeholderURL: URL, description: NSAttributedString?)
    case shareAction(title: NSAttributedString)
}
