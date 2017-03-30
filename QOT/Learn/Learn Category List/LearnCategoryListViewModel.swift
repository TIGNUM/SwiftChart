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
    /// Returns a `Double` between 0 and 1 how much of the contents have been learned. This is an expensive operation.
    var percentageLearned: Double { get }
    /// Returns a `Double` between 0 and 1 representing the cells radius.
    var radius: Double { get }
    /// Returns the cell's center.
    var center: CGPoint { get }
}

/// The view model of a `LearnCategoryListViewController`.
final class LearnCategoryListViewModel {
    private let _categories: Results<ContentCategory>
    
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    init(categories: Results<ContentCategory>) {
        self._categories = categories
    }
    
    /// The number of categories to display.
    var categoryCount: Index {
        return _categories.count
    }
    
    /// Returns the `LearnCategory` to display at `index`.
    func category(at index: Index) -> LearnCategory {
        return _categories[index]
    }
    
    var categories: [LearnCategory] {
        return _categories.map { $0 }
    }
}

extension ContentCategory: LearnCategory {
    var itemCount: Int {
        return contents.count
    }
    
    var viewedCount: Int {
        return contents.filter { $0.viewed }.count
    }
    
    var percentageLearned: Double {
        let total = contents.reduce(0) { $0.0 + $0.1.percentageViewed }
        return total / Double(contents.count)
    }
    
    var center: CGPoint {
        return CGPoint(x: centerX, y: centerY)
    }
}
