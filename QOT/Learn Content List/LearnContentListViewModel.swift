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

/// Encapsulates data to display in a `LearnContentListViewController`.
protocol LearnContent {
    /// The title of the content.
    var title: String { get }
    /// Whether the content has been viewed.
    var viewed: Bool { get }
    /// Time required in minutes to view the content.
    var minutesRequired: Int { get }
}

/// The view model of a `LearnContentListViewController`.
final class LearnContentListViewModel {
    private let category: ContentCategory
    
    /// The title to display.
    let title: String
    let updates =  PublishSubject<CollectionUpdate, NoError>()
    
    init(category: ContentCategory) {
        self.title = category.title
        self.category = category
    }
    
    /// The number of items of content to display.
    var itemCount: Index {
        return category.contents.count
    }
    
    /// Returns the `LearnContent` to display at `index`.
    func item(at index: Index) -> LearnContent {
        return category.contents[index]
    }
}

extension Content: LearnContent {
    var viewed: Bool {
        return percentageViewed > 0
    }
    
    var minutesRequired: Int {
        return items.reduce(0, { $0.0 + $0.1.secondsRequired }) / 60
    }
}
