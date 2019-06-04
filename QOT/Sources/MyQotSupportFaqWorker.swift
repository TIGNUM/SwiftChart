//
//  MyQotSupportFaqWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportFaqWorker {
    // MARK: - Properties
    
    private let services: Services
    private var items = [ContentCollection]()
    
    // MARK: - Init
    
    init(services: Services) {
        self.services = services
        fetchItems()
    }
}

// MARK: - Public

extension MyQotSupportFaqWorker {
    
    var itemCount: Int {
        return items.count
    }
    
    func item(at indexPath: IndexPath) -> ContentCollection {
        return items[indexPath.item]
    }
    
    func trackingID(at indexPath: IndexPath) -> Int {
        let cotent = item(at: indexPath)
        let contentItem = cotent.articleItems.filter { $0.format == ContentItemTextStyle.h3.rawValue }.first
        return contentItem?.remoteID.value ?? 0
    }
    
    func title(at indexPath: IndexPath) -> String {
        let cotent = item(at: indexPath)
        let contentItem = cotent.articleItems.filter { $0.format == ContentItemTextStyle.h3.rawValue }.first
        let text = contentItem?.valueText ?? ""
        return text.uppercased()
    }
    
    var faqHeaderText: String {
        return services.contentService.localizedString(for: ContentService.Support.faq.predicate) ?? ""
    }
}

// MARK: - Private

private extension MyQotSupportFaqWorker {
    
    func fetchItems() {
        items = Array(services.contentService.faq())
    }
}
