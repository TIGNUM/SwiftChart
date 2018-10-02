//
//  SupportFAQWorker.swift
//  QOT
//
//  Created by karmic on 01.10.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SupportFAQWorker {

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

extension SupportFAQWorker {

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> ContentCollection {
        return items[indexPath.item]
    }

    func title(at indexPath: IndexPath) -> NSAttributedString? {
        let cotent = item(at: indexPath)
        let contentItem = cotent.articleItems.filter { $0.format == "text.h3" }.first
        let text = contentItem?.valueText ?? ""
        return contentItem?.contentItemValue.style(textStyle: .h5,
                                                   text: text.uppercased(),
                                                   textColor: .white)
    }
}

// MARK: - Private

private extension SupportFAQWorker {

    func fetchItems() {
        items = Array(services.contentService.faq())
    }
}
