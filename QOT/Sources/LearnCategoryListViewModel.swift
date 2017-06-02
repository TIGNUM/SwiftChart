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

    // MARK: - Properties

    private let _categories: DataProvider<LearnContentCategory>
    let updates = PublishSubject<CollectionUpdate, NoError>()

    /// The number of categories to display.
    var categoryCount: Index {
        return _categories.count
    }

    var categories: [LearnContentCategory] {
        return _categories.items
    }

    // MARK: - Init

    init(categories: DataProvider<LearnContentCategory>) {
        self._categories = categories
    }

    /// Returns the `LearnCategory` to display at `index`.
    func category(at index: Index) -> LearnContentCategory {
        return _categories.item(at: index)
    }
}
