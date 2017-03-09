//
//  LearnContentListViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

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
    /// The title to display.
    let title: String = mockTitle
    let updates =  PublishSubject<CollectionUpdate, NoError>()
    
    /// The number of items of content to display.
    var itemCount: Index {
        return mockItems.count
    }
    
    /// Returns the `LearnContent` to display at `index`.
    func item(at index: Index) -> LearnContent {
        return mockItems[index]
    }
}

private let mockTitle = "Performance Mindset"

private struct MockContent: LearnContent {
    let title: String
    let viewed: Bool
    let minutesRequired: Int
}

private let mockItems: [MockContent] = [
    MockContent(title: "Performance mindset defined", viewed: false, minutesRequired: 5),
    MockContent(title: "Identify Mindset Killers", viewed: false, minutesRequired: 1),
    MockContent(title: "Eliminate Drama", viewed: false, minutesRequired: 2),
    MockContent(title: "From Low To High Performance", viewed: false, minutesRequired: 5),
    MockContent(title: "Optimal Performance State", viewed: true, minutesRequired: 5),
    MockContent(title: "Mindset Shift", viewed: false, minutesRequired: 4),
    MockContent(title: "Building on High Performance", viewed: false, minutesRequired: 5),
    MockContent(title: "Reframe Thoughts", viewed: false, minutesRequired: 3),
    MockContent(title: "Visulize Success", viewed: false, minutesRequired: 3),
    MockContent(title: "Control the Controllable", viewed: false, minutesRequired: 2),
    MockContent(title: "Mental Rehearsal", viewed: false, minutesRequired: 2),
    MockContent(title: "Set Intentions", viewed: false, minutesRequired: 4),
    MockContent(title: "Performance Mindset Defined", viewed: false, minutesRequired: 5)
]
