//
//  ArticleCollectionViewModel.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class ArticleCollectionViewModel {
    
    private let categories: AnyRealmCollection<ContentCategory>
    private let contentCollections: [ContentCollection]
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    var itemCount: Int {
        return contentCollections.count
    }

    func contentCollection(at index: Index) -> ContentCollection {
        return contentCollections[index]
    }

    func items(at index: Index) -> [ContentItem] {
        return Array(contentCollections[index].items)
    }

    func title(at index: Index) -> String {
        let selectedCategoryID = contentCollection(at: index).categoryIDs[0]
        return categories.filter { $0.remoteID == selectedCategoryID.value }[0].title
    }

    func description(at index: Index) -> String {
        return contentCollection(at: index).title
    }
    
    func date(at index: Index) -> String {
        return DateFormatter.shortDate.string(from: contentCollection(at: index).createdAt)
    }
    
    func duration(at index: Index) -> String {
        return "\(contentCollection(at: index).items.reduce(0, { $0.0 + $0.1.secondsRequired }) / 60) MIN" //TODO Localise?
    }

    func sortOrder(at index: Index) -> String {
        return String(format: ".%003d", contentCollection(at: index).sortOrder)
    }

    func previewImageURL(at index: Index) -> URL? {
        return contentCollection(at: index).thumbnailURL
    }

    // MARK: - Init

    init(categories: AnyRealmCollection<ContentCategory>, contentCollections: [ContentCollection]) {
        self.categories = categories
        self.contentCollections = contentCollections.sorted { (lhs: ContentCollection, rhs: ContentCollection) -> Bool in
            return lhs.sortOrder < rhs.sortOrder
        }
    }
}
