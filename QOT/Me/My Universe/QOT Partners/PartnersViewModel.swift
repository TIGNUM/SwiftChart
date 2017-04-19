//
//  PartnersViewModel.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class PartnersViewModel {

    // MARK: - Properties

    let items: [Partner]
    let selectedIndex: Index
    let updates = PublishSubject<CollectionUpdate, NoError>()

    init(items: [Partner], selectedIndex: Index) {
        self.items = items
        self.selectedIndex = selectedIndex
    }

    var itemCount: Int {
        return items.count
    }

    var selectedPartner: Partner {
        return items[selectedIndex]
    }

    func item(at index: Index) -> Partner {
        return items[index]
    }
}
