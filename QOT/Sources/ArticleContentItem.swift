//
//  ArticleContentItem.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol ArticleContentItem {

    var contentItemValue: ContentItemValue { get }

    var sortOrder: Int { get }

    var title: String { get }

    var value: String? { get }

    var valueText: String? { get }

    var valueDescription: String? { get }

    var valueImageURL: String? { get }

    var valueMediaURL: String? { get }

    var format: String { get }

    var contentItemTextStyle: ContentItemTextStyle { get }

    var remoteID: Int { get }

    var tabs: String { get }

}

extension ContentItem: ArticleContentItem {
    
}
