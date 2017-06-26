//
//  LearnCategoriesViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

/// The view model of a `LearnCategoryListViewController`.
final class LearnCategoryListViewModel {

    // MARK: - Properties

    private let _categories: AnyRealmCollection<ContentCategory>
    private let realmObserver: RealmObserver
    let updates = PublishSubject<CollectionUpdate, NoError>()

    /// The number of categories to display.
    var categoryCount: Index {
        return _categories.count
    }

    var categories: [ContentCategory] {
        return Array(_categories)
    }

    // MARK: - Init

    init(categories: AnyRealmCollection<ContentCategory>, realmObserver: RealmObserver) {
        self._categories = categories
        self.realmObserver = realmObserver

        realmObserver.handler = { [weak self] in
            self?.updates.next(.reload)
        }
    }

    /// Returns the `LearnCategory` to display at `index`.
    func category(at index: Index) -> ContentCategory {
        return categories[index]
    }
}
