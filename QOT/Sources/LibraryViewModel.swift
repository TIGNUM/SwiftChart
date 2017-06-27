//
//  LibraryViewModel.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

enum LibrarySectionStyle: Int {
    case lastPost = 0
    case category
}

final class LibraryViewModel {

    fileprivate let categories: AnyRealmCollection<ContentCategory>
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return categories.count
    }

    func styleForSection(_ section: Int) -> LibrarySectionStyle {
        return section == 0 ? .lastPost : .category
    }

    func titleForSection(_ section: Int) -> String {
         return categories[section].title
    }

    func contentCollection(at indexPath: IndexPath) -> [ContentCollection] {
        return Array(categories[indexPath.section].contentCollections)
    }

    func contentCount(at indexPath: IndexPath) -> Int {
        return categories[indexPath.section].contentCollections.count
    }

    init(categories: AnyRealmCollection<ContentCategory>) {
        self.categories = categories
    }
}
