//
//  LearnCategoriesViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

/// The view model of a `LearnCategoryListViewController`.
final class LearnCategoryListViewModel {
    private let _categories: DataProvider<LearnCategory>
    
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    init(categories: DataProvider<LearnCategory>) {
        self._categories = categories
    }
    
    /// The number of categories to display.
    var categoryCount: Index {
        return _categories.count
    }
    
    /// Returns the `LearnCategory` to display at `index`.
    func category(at index: Index) -> LearnCategory {
        return _categories.item(at: index)
    }
    
    var categories: [LearnCategory] {
        return _categories.items
    }
}
