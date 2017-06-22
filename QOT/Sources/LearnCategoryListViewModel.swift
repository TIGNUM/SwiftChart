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
    fileprivate let disposeBag = DisposeBag()
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

        categories.observeChange { [unowned self] (_) in
            self.updates.next(.reload)
        }.dispose(in: disposeBag)
    }

    /// Returns the `LearnCategory` to display at `index`.
    func category(at index: Index) -> LearnContentCategory {
        var counter = 0
        for i in 0..<_categories.count {
            let cat = _categories.item(at: i)
            if cat.itemCount > 0 {
                if counter == index {
                    return cat
                }
                counter += 1
            }
        }
        return _categories.item(at: 0)
    }
}
