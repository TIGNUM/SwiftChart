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

final class LearnCategoryListViewModel {

    struct Item {
        let title: String
        let viewedCount: Int
        let itemCount: Int
        let percentageLearned: Double

        init(category: ContentCategory) {
            title = category.title
            viewedCount = category.viewedCount(section: .learnStrategy)
            itemCount = category.itemCount(section: .learnStrategy)
            percentageLearned = Double(viewedCount) / Double(itemCount)
        }

        var titleShort: String {
            return title.replacingOccurrences(of: R.string.localized.learnContentPerformanceTitle().capitalized, with: "").trimmed
        }
    }

    // MARK: - Properties

    private let categories: AnyRealmCollection<ContentCategory>
    private var token: NotificationTokenHandler?
    let updates = PublishSubject<CollectionUpdate, Never>()

    // MARK: - Init

    init(services: Services) {
        self.categories = services.contentService.learnContentCategories()
        token = categories.observe { [unowned self] (change) in
            self.updates.next(change.update(section: 0))
        }.handler
    }

    var itemCount: Index {
        return categories.count
    }

    var areAllCompleted: Bool {
        for category in categories {
            if Item(category: category).percentageLearned < 1.0 { return false }
        }
        return true
    }

    func item(at index: Index) -> Item {
        return Item(category: categories[index])
    }
}
