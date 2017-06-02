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

    private var contentCollection: DataProvider<LearnContentCollection>
    private let categories: DataProvider<LearnContentCategory>
    let title: String
    let updates = PublishSubject<CollectionUpdate, NoError>()

    /// The number of items of content to display.
    var itemCount: Index {
        return contentCollection.items.count
    }

    var categoryCount: Int {
        return categories.count
    }

    func category(at index: Index) -> LearnContentCategory {
        return categories.item(at: index)
    }

    func updateContentCollection(at index: Index) {
        self.contentCollection = category(at: index).learnContent
        updates.next(.reload)
    }

    // MARK: - Init
    
    init(category: LearnContentCategory, allCategories: DataProvider<LearnContentCategory>) {
        self.title = category.title
        self.contentCollection = category.learnContent
        self.categories = allCategories
    }
    
    /// Returns the `LearnContent` to display at `index`.
    func item(at index: Index) -> LearnContentCollection {
        return contentCollection.item(at: index)
    }
}
