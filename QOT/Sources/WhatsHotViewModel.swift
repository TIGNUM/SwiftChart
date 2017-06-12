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
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    var itemCount: Int {
        return categories.count
    }
    
    func item(at index: Index) -> LearnWhatsHotContentItem {
        return categories.item(at: index).learnWhatsHotContent.item(at: 0).learnWhatsHotItems.item(at: 0)
    }

    // MARK: - Init

    init(categories: DataProvider<LearnWhatsHotContentCategory>) {
        self.categories = categories
    }
}
