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

    private let sections = mockCategorySections()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return sections.count
    }

    func numberOfItemsInSection(in section: Int) -> Int {
        return mediaItems(in: section).count
    }

    func item(at indexPath: IndexPath) -> LibraryItem.MediaItem {
        return mediaItems(in: indexPath.section)[indexPath.row]
    }

    func styleForSection(section: Int) -> LibraryItem.SectionStyle {
        switch sections[section] {
        case .collection(_, _, _, let sectionStyle): return sectionStyle
        }
    }

    private func mediaItems(in section: Index) -> [LibraryItem.MediaItem] {
        switch sections[section] {
        case .collection(_, _, let mediaItems, _): return mediaItems
        }
    }
}

enum LibraryItem {
    case collection(localID: String, sectinTitle: String, mediaItems: [MediaItem], sectionStyle: SectionStyle)

    enum MediaItem {
        case audio(localID: String, placeholderURL: URL, headline: String, text: String)
        case video(localID: String, placeholderURL: URL, headline: String, text: String)
    }

    enum SectionStyle {
        case lastPost
        case category
    }
}

private func mockCategorySections() -> [LibraryItem] {
    return [
        .collection(
            localID: UUID().uuidString,
            sectinTitle: "Latest Posts",
            mediaItems: mockMixedMediaItems(),
            sectionStyle: .lastPost
        ),

        .collection(
            localID: UUID().uuidString,
            sectinTitle: "PERFORMANCE CATEGORY 1",
            mediaItems: mockMixedMediaItems(),
            sectionStyle: .category
        ),

        .collection(
            localID: UUID().uuidString,
            sectinTitle: "PERFORMANCE CATEGORY 2",
            mediaItems: mockMixedMediaItems(),
            sectionStyle: .category
        ),

        .collection(
            localID: UUID().uuidString,
            sectinTitle: "PERFORMANCE CATEGORY 3",
            mediaItems: mockMixedMediaItems(),
            sectionStyle: .category
        ),

        .collection(
            localID: UUID().uuidString,
            sectinTitle: "PERFORMANCE CATEGORY 4",
            mediaItems: mockMixedMediaItems(),
            sectionStyle: .category
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
