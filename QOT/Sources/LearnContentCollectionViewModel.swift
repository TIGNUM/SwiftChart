//
//  LearnContentCollectionViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

/// The view model of a `LearnContentListViewController`.
final class LearnContentCollectionViewModel {

    // MARK: - Properties

    private let categories: DataProvider<LearnContentCategory>

    let updates = PublishSubject<CollectionUpdate, NoError>()

    init(categories: DataProvider<LearnContentCategory>, selectedIndex: Index) {
        self.categories = categories
    }

    var categoryCount: Int {
        return categories.count
    }

    func category(at index: Index) -> LearnContentCategory {
        return  categories.item(at: index)
    }

    func itemCount(categoryIndex: Index) -> Int {
        return category(at: categoryIndex).learnContent.count
    }

    func item(at indexPath: IndexPath) -> LearnContentCollection {
        return category(at: indexPath.section).learnContent.item(at: indexPath.row)
    }
}
