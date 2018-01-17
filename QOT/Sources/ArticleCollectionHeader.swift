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

    init(content: ContentCollection) {
        articleTitle = content.contentCategories.first?.title ?? ""
        articleSubTitle = content.title
        articleDate = DateFormatter.shortDate.string(from: content.createdAt)
        articleDuration = "\(content.items.reduce(0) { $0 + $1.secondsRequired } / 60) MIN"
        articleContentCollectionID = content.remoteID.value ?? 0
    }

    init(articleTitle: String,
         articleSubTitle: String,
         articleDate: String,
         articleDuration: String,
         articleContentCollectionID: Int) {
        self.articleTitle = articleTitle
        self.articleSubTitle = articleSubTitle
        self.articleDate = articleDate
        self.articleDuration = articleDuration
        self.articleContentCollectionID = articleContentCollectionID
    }
}
