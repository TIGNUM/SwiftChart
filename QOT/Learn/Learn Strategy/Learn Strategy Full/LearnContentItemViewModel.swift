//
//  LearnContentItemViewModel.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import QOTDatabase

final class LearnContentItemViewModel {

    // MARK: - Properties

    private let contentCollection: LearnContentCollection
    private var sections = [[LearnContentItem]]()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return sections.count
    }

    // MARK: - Init

    init(contentCollection: LearnContentCollection) {
        self.contentCollection = contentCollection
        self.sections = [contentCollection.contentItems.items, mockReadMoreContentItems]
    }

    // MARK: - Helper Fucntions

    func numberOfItemsInSection(in section: Int) -> Int {
        return learnContentItems(in: section).count
    }

    func contentItem(at indexPath: IndexPath) -> ContentItemValue? {
        return learnContentItems(in: indexPath.section)[indexPath.row].contentItemValue
    }

    func learnContentItems(in section: Int) -> [LearnContentItem] {
        return sections[section]
    }
}

private struct ReadMoreItem: LearnContentItem {
    let viewed: Bool
    let title: String
    let contentItemValue: ContentItemValue

    var trackableEntityID: Int {
        return Int(randomNumber)
    }
}

private var mockReadMoreContentItems: [LearnContentItem] {
    return [
        ReadMoreItem(
            viewed: false,
            title: "Read More",
            contentItemValue: ContentItemValue.text("34 Articels")
        ),

        ReadMoreItem(
            viewed: false,
            title: "Leverage Stress Benefits",
            contentItemValue: ContentItemValue.text("5 Min to read")
        ),

        ReadMoreItem(
            viewed: false,
            title: "The small change that do",
            contentItemValue: ContentItemValue.text("4 min read")
        )
    ]
}
