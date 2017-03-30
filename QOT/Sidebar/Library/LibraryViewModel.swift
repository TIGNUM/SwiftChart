//
//  LibraryViewModel.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class LibraryViewModel {

    private let sections = [LibrarySection]()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return sections.count
    }

    func numberOfItemsInSection(in section: Int) -> Int {
        return items(in: section).count
    }

    func item(at indexPath: IndexPath) -> LibraryItem {
        return items(in: indexPath.section)[indexPath.row]
    }

    private func items(in section: Int) -> [LibraryItem] {
        switch sections[section] {
        case .lastPostItems(let lastPostItem): return lastPostItem
        case .categoryItems(let categoryItems): return categoryItems
        }
    }
}

private enum LibrarySection {
    case lastPostItems([LibraryItem])
    case categoryItems([LibraryItem])
}

enum LibraryItem {
    case collection(localID: String, sectinTitle: String, mediaItems: [MediaItem])

    enum MediaItem {
        case audio(localID: String, placeholderURL: URL, headline: String, text: String)
        case video(localID: String, placeholderURL: URL, headline: String, text: String)
    }
}

private func mockLibrarySections() -> [LibrarySection] {
    return [
        .lastPostItems(mockLastPostItem()),
        .categoryItems(mockCategoryItems())
    ]
}

private func mockLastPostItem() -> [LibraryItem] {
    return [
        .collection(
            localID: UUID().uuidString,
            sectinTitle: "Latest Posts",
            mediaItems: mockMixedMediaItems()
        )
    ]
}

private func mockCategoryItems() -> [LibraryItem] {
    return [
        .collection(
            localID: UUID().uuidString,
            sectinTitle: "PERFORMANCE CATEGORY 1",
            mediaItems: mockMixedMediaItems()
        ),

        .collection(
            localID: UUID().uuidString,
            sectinTitle: "PERFORMANCE CATEGORY 2",
            mediaItems: mockMixedMediaItems()
        ),

        .collection(
            localID: UUID().uuidString,
            sectinTitle: "PERFORMANCE CATEGORY 3",
            mediaItems: mockMixedMediaItems()
        ),

        .collection(
            localID: UUID().uuidString,
            sectinTitle: "PERFORMANCE CATEGORY 4",
            mediaItems: mockMixedMediaItems()
        )
    ]
}

private func mockMixedMediaItems() -> [LibraryItem.MediaItem] {
    return [
        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore",
            text: "Ipsum Text"
        ),

        .audio(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore",
            text: "Ipsum Text"
        ),

        .audio(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore",
            text: "Ipsum Text"
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore",
            text: "Ipsum Text"
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore",
            text: "Ipsum Text"
        )
    ]
}
