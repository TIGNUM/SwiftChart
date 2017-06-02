//
//  SidebarViewModel.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class SidebarViewModel {

    // MARK: - Properties

    var sidebarContentCategories: DataProvider<SidebarContentCategory>
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    var itemCount: Int {        
        return sidebarContentCategories.count
    }

    // MARK: - Init

    init(sidebarContentCategories: DataProvider<SidebarContentCategory>) {
        self.sidebarContentCategories = sidebarContentCategories
    }

    // MARK: - Helper
    
    func sidebarCategory(at index: Index) -> SidebarContentCategory {
        return sidebarContentCategories.item(at: index)
    }

    func sidebarCollection(at index: Index) -> SidebarContentCollection? {
        guard
            sidebarContentCategories.item(at: index).sidebarContentCollection.items.isEmpty == false,
            sidebarContentCategories.item(at: index).sidebarContentCollection.items.count <= index else {
                return nil
        }

        return sidebarContentCategories.item(at: index).sidebarContentCollection.item(at: index - 1)
    }
}
