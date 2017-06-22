//
//  WhatsHotViewModel.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class WhatsHotViewModel {
    
    private let categories: DataProvider<LearnWhatsHotContentCategory>
    private let contentCollections: [LearnWhatsHotContentCollection]
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    var itemCount: Int {
        return contentCollections.count
    }

    func contentCollection(at index: Index) -> LearnWhatsHotContentCollection {
        return contentCollections[index]
    }

    func items(at index: Index) -> [LearnWhatsHotContentItem] {
        return contentCollections[index].learnWhatsHotItems.items
    }

    func title(at index: Index) -> String {
        let selectedCategoryID = contentCollection(at: index).categoryIDs[0]
        return categories.items.filter { $0.remoteID == selectedCategoryID.value }[0].title
    }

    func description(at index: Index) -> String {
        return contentCollection(at: index).title
    }

    func sortOrder(at index: Index) -> String {
        return String(format: ".%003d", contentCollection(at: index).sortOrder)
    }

    func previewImageURL(at index: Index) -> URL? {
        return contentCollection(at: index).thumbnailURL
    }

    // MARK: - Init

    init(categories: DataProvider<LearnWhatsHotContentCategory>, contentCollections: [LearnWhatsHotContentCollection]) {
        self.categories = categories
        self.contentCollections = contentCollections.sorted { (lhs: LearnWhatsHotContentCollection, rhs: LearnWhatsHotContentCollection) -> Bool in
            return lhs.sortOrder < rhs.sortOrder
        }
    }
}
