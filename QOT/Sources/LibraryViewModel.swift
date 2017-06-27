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

final class LibraryViewModel {

    // MARK: - Properties

    fileprivate let categories: AnyRealmCollection<ContentCategory>
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return categories.count
    }

    // MARK: - Init

    init(categories: AnyRealmCollection<ContentCategory>) {
        self.categories = categories
    }
}

// MARK: - Public

extension LibraryViewModel {

    func titleForSection(_ section: Int) -> NSAttributedString {
        let title = categories[section].title.uppercased()
        return section == 0 ? Style.headlineSmall(title, .white).attributedString() : Style.subTitle(title, .white).attributedString()
    }

    func contentCollection(at indexPath: IndexPath) -> [ContentCollection] {
        return Array(categories[indexPath.section].contentCollections)
    }

    func contentCount(at indexPath: IndexPath) -> Int {
        return categories[indexPath.section].contentCollections.count
    }
}
