//
//  ArticleContentCategory.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// Encapsulates data to display in a `LearnCategoryListViewController`.
protocol ArticleContentCategory: TrackableEntity {

    var articleContent: DataProvider<ArticleContentCollection> { get }

    var title: String { get }

    var remoteID: Int { get }
}

extension ContentCategory: ArticleContentCategory {

    var articleContent: DataProvider<ArticleContentCollection> {
        return DataProvider(items: contentCollections, map: { $0 as ArticleContentCollection })
    }
}
