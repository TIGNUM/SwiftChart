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

    private(set) public var contentCollection: DataProvider<LearnContentCollection>
    private let categories: DataProvider<LearnContentCategory>
    let title: String
    let updates = PublishSubject<CollectionUpdate, NoError>()

    /// The number of items of content to display.
    var itemCount: Int {
        return contentCollection.items.count
    }

    var categoryCount: Int {
        var counter = 0
        for i in 0..<categories.count {
            let cat = categories.item(at: i)
            counter += cat.itemCount > 0 ? 1 : 0
        }
        return counter
    }

    func category(at index: Index) -> LearnContentCategory {
        var counter = 0
        for i in 0..<categories.count {
            let cat = categories.item(at: i)
            if cat.itemCount > 0 {
                if counter == index {
                    return cat
                }
                counter += 1
            }
        }
        return categories.item(at: 0)
    }

    func updateContentCollection(at index: Index) {
        self.contentCollection = category(at: index).learnContent
        //        updates.next(.reload)
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
