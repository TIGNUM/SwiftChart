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
//        Section(title: "PERFORMANCE CATEGORY 2", items: mockMixedMediaItems(), style: .category),
//        Section(title: "PERFORMANCE CATEGORY 3", items: mockMixedMediaItems(), style: .category),
//        Section(title: "PERFORMANCE CATEGORY 4", items: mockMixedMediaItems(), style: .category)
    ]
}

private func mockMixedMediaItems() -> [LibraryMediaItem] {
    return [
        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://cdn.pixabay.com/photo/2011/07/25/23/42/comb-8351_960_720.jpg")!,
            headline: "Headline Lore Ipsum Text",
            text: "VIDEO"
        ),

        .audio(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://cdn.pixabay.com/photo/2011/01/17/18/03/iguana-4612_960_720.jpg")!,
            headline: "Headline Lore Ipsum Text",
            text: "AUDIO"
        ),

        .audio(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://cdn.pixabay.com/photo/2013/02/17/03/30/utah-82401_960_720.jpg")!,
            headline: "Headline Lore Ipsum Text",
            text: "AUDIO"
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://cdn.pixabay.com/photo/2013/11/18/17/00/sunrise-212692_960_720.jpg")!,
            headline: "Headline Lore Ipsum Text",
            text: "VIDEO"
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string: "https://cdn.pixabay.com/photo/2017/03/26/12/13/countryside-2175353_960_720.jpg")!,
            headline: "Headline Lore Ipsum Text",
            text: "VIDEO"
        )
    ]
}
