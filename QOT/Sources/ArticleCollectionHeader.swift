//
//  ArticleCollectionHeader.swift
//  QOT
//
//  Created by Lee Arromba on 12/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct ArticleCollectionHeader {
    let articleTitle: String
    let articleSubTitle: String
    let articleDate: String
    let articleDuration: String
    let articleContentCollectionID: Int

    init(contentCollection: ContentCollection) {
        articleTitle = contentCollection.contentCategories.first?.title ?? ""
        articleSubTitle = contentCollection.title
        articleDate = DateFormatter.shortDate.string(from: contentCollection.createdAt)
        articleDuration = "\(contentCollection.items.reduce(0) { $0 + $1.secondsRequired } / 60) MIN"
        articleContentCollectionID = contentCollection.remoteID.value ?? 0
    }

    init(articleTitle: String, articleSubTitle: String, articleDate: String, articleDuration: String, articleContentCollectionID: Int) {
        self.articleTitle = articleTitle
        self.articleSubTitle = articleSubTitle
        self.articleDate = articleDate
        self.articleDuration = articleDuration
        self.articleContentCollectionID = articleContentCollectionID
    }
}
