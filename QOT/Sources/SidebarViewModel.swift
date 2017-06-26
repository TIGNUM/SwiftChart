//
//  SidebarViewModel.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class SidebarViewModel {

    // MARK: - Properties

    var sidebarContentCategories: AnyRealmCollection<ContentCategory>
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    var itemCount: Int {        
        return sidebarContentCategories.count
    }

    // MARK: - Init

    init(sidebarContentCategories: AnyRealmCollection<ContentCategory>) {
        self.sidebarContentCategories = sidebarContentCategories
    }

    // MARK: - Helper
    
    func sidebarCategory(at index: Index) -> ContentCategory {
        return sidebarContentCategories[index]
    }

    func sidebarCollection(at index: Index) -> ContentCollection? {
        let contentCollections = sidebarCategory(at: index).contentCollections
        guard contentCollections.isEmpty == false, contentCollections.count <= index else {
                return nil
        }
        return contentCollections[index - 1]
    }
}
