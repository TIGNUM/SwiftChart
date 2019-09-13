//
//  MyQotSupportFaqWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSupportFaqWorker {
    // MARK: - Properties

    private let contentService: qot_dal.ContentService
    private var items = [QDMContentCollection]()

    // MARK: - Init

    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }
}

// MARK: - Public

extension MyQotSupportFaqWorker {

    func fetchItems(_ completion: @escaping() -> Void) {
        contentService.getContentCategory(.FAQ) { (category) in
            self.items = category?.contentCollections ?? []
            completion()
        }
    }

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> QDMContentCollection {
        return items[indexPath.item]
    }

    func trackingID(at indexPath: IndexPath) -> Int {
        let content = item(at: indexPath)
        let contentItem = content.contentItems.filter { $0.format == .header3 }.first
        return contentItem?.remoteID ?? 0
    }

    func title(at indexPath: IndexPath) -> String {
        let content = item(at: indexPath)
        let contentItem = content.contentItems.filter { $0.format == .header3 }.first
        let text = contentItem?.valueText ?? content.title
        return text.uppercased()
    }

    var faqHeaderText: String {
        return ScreenTitleService.main.localizedString(for: .SupportFaq)
    }
}
