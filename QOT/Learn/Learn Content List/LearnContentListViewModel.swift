//
//  LearnContentListViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

/// The view model of a `LearnContentListViewController`.
final class LearnContentListViewModel {
    private let content: DataProvider<LearnContent>
    
    /// The title to display.
    let title: String
    let updates =  PublishSubject<CollectionUpdate, NoError>()
    
    init(category: LearnCategory) {
        self.title = category.title
        self.content = category.learnContent
    }

    /// The number of items of content to display.
    var itemCount: Index {
        return content.count
    }
    
    /// Returns the `LearnContent` to display at `index`.
    func item(at index: Index) -> LearnContent {
        return content.item(at: index)
    }
}
