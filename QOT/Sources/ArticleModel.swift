//
//  ArticleModel.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Article {

    struct Item: Equatable {
        let remoteID: Int
        let type: ContentItemValue
        let content: String
        let format: String
        let bundledAudioURL: URL?
        let thumbnailURL: String?

        init(remoteID: Int,
             type: ContentItemValue,
             content: String,
             format: String,
             bundledAudioURL: URL?,
             thumbnailURL: String?) {
            self.type = type
            self.remoteID = remoteID
            self.content = content
            self.format = format
            self.bundledAudioURL = bundledAudioURL
            self.thumbnailURL = thumbnailURL
        }

        init(remoteID: Int, type: ContentItemValue) {
            self.type = type
            self.remoteID = remoteID
            content = ""
            format = ""
            bundledAudioURL = nil
            thumbnailURL = nil
        }

        init(type: ContentItemValue) {
            self.type = type
            remoteID = 0
            content = ""
            format = ""
            bundledAudioURL = nil
            thumbnailURL = nil
        }

        init(type: ContentItemValue, content: String) {
            self.type = type
            self.content = content
            remoteID = 0
            format = ""
            bundledAudioURL = nil
            thumbnailURL = nil
        }

        static func == (lhs: Article.Item, rhs: Article.Item) -> Bool {
            return  lhs.remoteID == rhs.remoteID &&
                    lhs.content == rhs.content &&
                    lhs.format == rhs.format &&
                    lhs.bundledAudioURL == rhs.bundledAudioURL &&
                    lhs.thumbnailURL == rhs.thumbnailURL
        }
    }

    struct Header {
        let categoryTitle: String
        let title: String
        let author: String?
        let publishDate: Date?
        let timeToRead: Int?
        let imageURL: String?
        init(categoryTitle: String, title: String, author: String?, publishDate: Date?, timeToRead: Int?, imageURL: String?) {
            self.categoryTitle = categoryTitle
            self.title = title
            self.author = author
            self.publishDate = publishDate
            self.timeToRead = timeToRead
            self.imageURL = imageURL
        }
        init() {
            categoryTitle = ""
            title = ""
            author = nil
            publishDate = nil
            timeToRead = nil
            imageURL = nil
        }
    }

    struct RelatedArticleWhatsHot {
        let remoteID: Int
        let title: String
        let publishDate: Date?
        let author: String?
        let timeToRead: String
        let imageURL: URL?
        let isNew: Bool
    }

    struct RelatedArticleStrategy {
        let title: String
        let durationString: String
        let remoteID: Int
    }
}
