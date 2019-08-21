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
        return MyQotAboutUsModel.MyQotAboutUsModelItem.aboutValues.count
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

    func title(at indexPath: IndexPath, _ completion: @escaping(String) -> Void) {
        guard let item = MyQotAboutUsModel.MyQotAboutUsModelItem(rawValue: indexPath.row) else {
            completion("")
            return
        }
        item.title(for: contentService) { (text) in
            completion(text)
        }
    }

    func subtitle(at indexPath: IndexPath, _ completion: @escaping(String) -> Void) {
        guard let item = MyQotAboutUsModel.MyQotAboutUsModelItem(rawValue: indexPath.row) else {
            completion("")
            return
        }
        item.subtitle(for: contentService) { (text) in
            completion(text)
        }
    }

    func contentCollection(item: MyQotAboutUsModel.MyQotAboutUsModelItem,
                           _ completion: @escaping(QDMContentCollection?) -> Void) {
        item.contentCollection(for: contentService) { (collection) in
            completion(collection)
        }
    }

    func aboutUsText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(qot_dal.ContentService.AboutUs.aboutTignum.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }
}
