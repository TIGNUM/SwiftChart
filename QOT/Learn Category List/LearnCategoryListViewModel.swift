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

/// Encapsulates data to display in a `LearnCategoryListViewController`.
protocol LearnCategory {
    /// The title of `self`.
    var title: String { get }
    /// The number of items that belong `self`.
    var itemCount: Int { get }
    /// The number of items that belong `self` and have been viewed.
    var viewedCount: Int { get }
    /// Returns a `Double` between 0 and 1 how much of the contents at `index` have been learned.
    func percentageLearned(at index: Index) -> Double
}

/// The view model of a `LearnCategoryListViewController`.
final class LearnCategoryListViewModel {
    private let categories: Results<ContentCategory>
    
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    init(categories: Results<ContentCategory>) {
        self.categories = categories
    }
    
    /// The number of categories to display.
    var categoryCount: Index {
        let count = categories.count
        precondition(count == 6, "The category count is currently hardcoded as 6")
        return count
    }
    
    /// Returns the `LearnCategory` to display at `index`.
    func category(at index: Index) -> LearnCategory {
        return categories[index] as LearnCategory
    }
}

extension ContentCategory: LearnCategory {
    var itemCount: Int {
        return contents.count
    }
    
    var viewedCount: Int {
        return contents.filter { $0.viewed }.count
    }
    
    func percentageLearned(at index: Index) -> Double {
        return contents[index].percentageViewed
    }
}
