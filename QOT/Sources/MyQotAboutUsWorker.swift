//
//  MyQotAboutUsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAboutUsWorker {

    private let services: Services

    init(services: Services) {
        self.services = services
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
        return item.trackingKeys(for: services)
    }

    func title(at indexPath: IndexPath) -> String {
        guard let item = MyQotAboutUsModel.MyQotAboutUsModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.title(for: services)
    }

    func subtitle(at indexPath: IndexPath) -> String {
        guard let item = MyQotAboutUsModel.MyQotAboutUsModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.subtitle(for: services)
    }

    func contentCollection(_ item: MyQotAboutUsModel.MyQotAboutUsModelItem) -> ContentCollection? {
        return item.contentCollection(for: services.contentService)
    }

    var aboutUsText: String {
        return services.contentService.localizedString(for: ContentService.AboutUs.aboutTignum.predicate) ?? ""
    }
}
