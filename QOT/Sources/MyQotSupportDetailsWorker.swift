//
//  MyQotSupportDetailsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSupportDetailsWorker {
    // MARK: - Properties

    private let contentService: qot_dal.ContentService
    let category: ContentCategory
    private var items = [QDMContentCollection]()

    // MARK: - Init

    init(contentService: qot_dal.ContentService, category: ContentCategory) {
        self.contentService = contentService
        self.category = category
    }
}

// MARK: - Public

extension MyQotSupportDetailsWorker {

    func fetchItems(_ completion: @escaping() -> Void) {
        contentService.getContentCategory(category) { (category) in
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

    var headerText: String {
        switch category {
        case .UsingQOT:
            return AppTextService.get(AppTextKey.my_qot_my_profile_support_using_qot_view_title)
        default:
            return AppTextService.get(AppTextKey.my_qot_my_profile_support_faq_view_title)
        }
    }
}
