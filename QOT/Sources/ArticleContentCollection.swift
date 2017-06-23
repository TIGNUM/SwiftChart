//
//  ArticleContentCollection.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol ArticleContentCollection: TrackableEntity {

    var title: String { get }

    var localID: String { get }

    var selected: Bool { get }

    var articleItems: DataProvider<ArticleContentItem> { get }

    var categoryIDs: List<IntObject> { get }

    var sortOrder: Int { get }

    var thumbnailURL: URL? { get}

    var relatedContentIDs: [Int] { get }
}

extension ContentCollection: ArticleContentCollection {

    var articleItems: DataProvider<ArticleContentItem> {
        return DataProvider(items: items, map: { $0 as ArticleContentItem })
    }

    var thumbnailURL: URL? {
        guard let stringURL = thumbnailURLString else {
            return nil
        }

        return URL(string: stringURL)
    }
}
