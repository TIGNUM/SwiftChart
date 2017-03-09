//
//  LearnCategoriesViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

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
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    /// The number of categories to display.
    var categoryCount: Index {
        return mockCategories.count
    }
    
    /// Returns the `LearnCategory` to display at `index`.
    func category(at index: Index) -> LearnCategory {
        return mockCategories[index]
    }
}

// MARK: Mock data

private struct MockCategory: LearnCategory {
    let title: String
    let percentages: [Double]
    
    var itemCount: Int {
        return percentages.count
    }
    
    var viewedCount: Int {
        return percentages.filter { $0 > 0 }.count
    }
    
    func percentageLearned(at index: Index) -> Double {
        return percentages[index]
    }
}

private let mockCategories: [MockCategory] = [
    MockCategory(title: "MINDSET", percentages: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    MockCategory(title: "RECOVERY", percentages: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    MockCategory(title: "FOUNDATION", percentages: [1, 1, 1, 0.5, 0.5]),
    MockCategory(title: "NUTRITION", percentages: [1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0]),
    MockCategory(title: "NEW", percentages: [1, 0, 0, 0]),
    MockCategory(title: "MOVEMENT", percentages: [1, 1, 1, 0, 0, 0, 0, 0, 0, 0]),
    MockCategory(title: "HABITUATION", percentages: [1, 1, 1, 1, 1, 0.5, 0, 0, 0, 0])
]
