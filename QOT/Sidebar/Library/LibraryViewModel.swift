//
//  LibraryViewModel.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 30/03/2017.
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
        return sections[section].items.count
    }

    func styleForSection(_ section: Int) -> LibrarySectionStyle {
        return sections[section].style
    }

    func titleForSection(_ section: Int) -> String {
         return sections[section].title
    }

    func item(at indexPath: IndexPath) -> LibraryMediaItem {
        return sections[indexPath.section].items[indexPath.row]
    }
}

enum LibraryMediaItem {
    case audio(localID: String, placeholderURL: URL, headline: String, text: String)
    case video(localID: String, placeholderURL: URL, headline: String, text: String)
}

enum LibrarySectionStyle {
    case lastPost
    case category
}

private struct Section {
    let title: String
    let items: [LibraryMediaItem]
    let style: LibrarySectionStyle
}

private func mockCategorySections() -> [Section] {
    return [
        Section(title: "Latest Posts", items: mockMixedMediaItems(), style: .lastPost),
        Section(title: "PERFORMANCE CATEGORY 1", items: mockMixedMediaItems(), style: .category),
        Section(title: "PERFORMANCE CATEGORY 2", items: mockMixedMediaItems(), style: .category),
        Section(title: "PERFORMANCE CATEGORY 3", items: mockMixedMediaItems(), style: .category),
        Section(title: "PERFORMANCE CATEGORY 4", items: mockMixedMediaItems(), style: .category)
    ]
}

private func mockMixedMediaItems() -> [LibraryMediaItem] {
    return [
        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore Ipsum Text",
            text: "VIDEO"
        ),

        .audio(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore Ipsum Text",
            text: "AUDIO"
        ),

        .audio(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore Ipsum Text",
            text: "AUDIO"
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore Ipsum Text",
            text: "VIDEO"
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://example.com")!,
            headline: "Headline Lore Ipsum Text",
            text: "VIDEO"
        )
    ]
}
