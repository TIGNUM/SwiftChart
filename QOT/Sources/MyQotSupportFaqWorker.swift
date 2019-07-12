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
        contentService.getContentCollectionBySection(.FAQ) {[weak self] (collection) in
            self?.items = collection?.filter({ $0.section.rawValue == "FAQ" && $0.title != "FAQ" }) ?? []
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
        let text = contentItem?.valueText ?? ""
        return text.uppercased()
    }

    func faqHeaderText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.Support.faq.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }
}
