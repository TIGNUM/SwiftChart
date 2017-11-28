//
//  ArticleCollectionViewData.swift
//  QOT
//
//  Created by Lee Arromba on 28/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct ArticleCollectionViewData {
    struct Item {
        let title: String
        let description: String
        let date: String
        let duration: String
        let articleDate: String
        let sortOrder: String
        let previewImageURL: URL?
        let contentCollectionID: Int
    }

    let items: [Item]
    var isReady: Bool {
        return items.count > 0
    }
}
