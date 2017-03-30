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

    func item(at indexPath: IndexPath) -> LearnStrategyItem {
        return items(in: indexPath.section)[indexPath.row]
    }

    private func items(in section: Int) -> [LearnStrategyItem] {
        return []
    }
}

private enum LibrarySection {
    case lastPostItems(LibraryItem)
    case categoryItems([LibraryItem])
}

enum LibraryItem {
    case header(localID: String, title: String)
    case collection(localID: String, headline: String, text: String, media: MediaType)

    enum MediaType {
        case audio(localID: String, placeholderURL: URL, title: String)
        case video(localID: String, placeholderURL: URL, title: String)
    }
}

private func mock
