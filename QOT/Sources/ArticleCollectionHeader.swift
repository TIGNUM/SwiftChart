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
    let articleDate: Date
    let articleDuration: String
    let articleContentCollectionID: Int
	let thumbnail: URL?
    let author: String?
    let shareableLink: String?

    init(content: ContentCollection) {
        articleTitle = content.contentCategories.first?.title ?? ""
        articleSubTitle = content.title
        articleDate = content.createdAt
        articleDuration = "\(content.items.reduce(0) { $0 + $1.secondsRequired } / 60) MIN"
        articleContentCollectionID = content.remoteID.value ?? 0
		thumbnail = content.thumbnailURL
        author = content.author
        shareableLink = content.shareableLink
    }

    init(articleTitle: String,
         articleSubTitle: String,
         articleDate: Date,
         articleDuration: String,
         articleContentCollectionID: Int,
		 thumbnail: URL?,
         author: String?,
         shareableLink: String?) {
        self.articleTitle = articleTitle
        self.articleSubTitle = articleSubTitle
        self.articleDate = articleDate
        self.articleDuration = articleDuration
        self.articleContentCollectionID = articleContentCollectionID
		self.thumbnail = thumbnail
        self.author = author
        self.shareableLink = shareableLink
    }
}
