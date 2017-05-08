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

    private let contentCollection: DataProvider<LearnContentCollection>
    let title: String
    let updates =  PublishSubject<CollectionUpdate, NoError>()

    /// The number of items of content to display.
    var itemCount: Index {
        return contentCollection.items.count
    }

    // MARK: - Init
    
    init(category: LearnContentCategory) {
        self.title = category.title
        self.contentCollection = category.learnContent
    }
    
    /// Returns the `LearnContent` to display at `index`.
    func item(at index: Index) -> LearnContentCollection {
        return contentCollection.item(at: index)
    }
}
