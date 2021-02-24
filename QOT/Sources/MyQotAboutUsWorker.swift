//
//  MyQotAboutUsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotAboutUsWorker {

    private let contentService: ContentService

    init(contentService: ContentService) {
        self.contentService = contentService
    }

    func itemCount() -> Int {
        return MyQotAboutUsModel.Item.allCases.count
    }

    func item(at indexPath: IndexPath) -> MyQotAboutUsModel.Item? {
        guard let item = MyQotAboutUsModel.Item(rawValue: indexPath.row) else { return nil }
        return item
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        guard let item = MyQotAboutUsModel.Item(rawValue: indexPath.row) else {
            return String.empty
        }
        return item.trackingKeys()
    }

    func title(at indexPath: IndexPath) -> String {
        guard let item = MyQotAboutUsModel.Item(rawValue: indexPath.row) else {
            return String.empty
        }
        return item.title(for: contentService)
    }

    func contentCollection(item: MyQotAboutUsModel.Item,
                           _ completion: @escaping(QDMContentCollection?) -> Void) {
        item.contentCollection(for: contentService) { (collection) in
            completion(collection)
        }
    }

    var aboutUsText: String {
        return AppTextService.get(.my_qot_my_profile_section_about_us_section_header_title)
    }
}
