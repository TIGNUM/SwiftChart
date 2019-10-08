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

    private let contentService: qot_dal.ContentService

    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }

    func itemCount() -> Int {
        return MyQotAboutUsModel.MyQotAboutUsModelItem.allCases.count
    }

    func item(at indexPath: IndexPath) -> MyQotAboutUsModel.MyQotAboutUsModelItem? {
        guard let item = MyQotAboutUsModel.MyQotAboutUsModelItem(rawValue: indexPath.row) else { return nil }
        return item
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        guard let item = MyQotAboutUsModel.MyQotAboutUsModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.trackingKeys()
    }

    func title(at indexPath: IndexPath) -> String {
        guard let item = MyQotAboutUsModel.MyQotAboutUsModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.title(for: contentService)
    }

    func subtitle(at indexPath: IndexPath) -> String {
        guard let item = MyQotAboutUsModel.MyQotAboutUsModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.subtitle(for: contentService)
    }

    func contentCollection(item: MyQotAboutUsModel.MyQotAboutUsModelItem,
                           _ completion: @escaping(QDMContentCollection?) -> Void) {
        item.contentCollection(for: contentService) { (collection) in
            completion(collection)
        }
    }

    var aboutUsText: String {
        return ScreenTitleService.main.localizedString(for: .MyQotProfileAboutTignum)
    }
}
