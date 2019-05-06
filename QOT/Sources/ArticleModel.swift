//
//  ArticleModel.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Article {

    struct Item {
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
    }

    struct Header {
        let categoryTitle: String
        let title: String
        let author: String?
        let publishDate: Date?
        let timeToRead: Int?
        let imageURL: String?
    }

    struct RelatedArticle {
        let remoteID: Int
        let title: String
        let publishDate: Date?
        let author: String?
        let timeToRead: String
        let imageURL: URL?
        let isNew: Bool
    }
}
