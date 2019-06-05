//
//  MyQotSupportWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportWorker {

    private let services: Services

    init(services: Services) {
        self.services = services
    }

    func itemCount() -> Int {
        return MyQotSupportModel.MyQotSupportModelItem.supportValues.count
    }

    func item(at indexPath: IndexPath) -> MyQotSupportModel.MyQotSupportModelItem? {
        guard let item = MyQotSupportModel.MyQotSupportModelItem(rawValue: indexPath.row) else { return nil }
        return item
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.trackingKeys(for: services)
    }

    func title(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.title(for: services)
    }

    func subtitle(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.subtitle(for: services)
    }

    func contentCollection(_ item: MyQotSupportModel.MyQotSupportModelItem) -> ContentCollection? {
        return item.contentCollection(for: services.contentService)
    }

    var supportText: String {
        return services.contentService.localizedString(for: ContentService.Support.support.predicate) ?? ""
    }

    var email: String {
        if let supportEmail = services.userService.user()?.firstLevelSupportEmail, supportEmail.isEmpty == false {
            return supportEmail
        }
        return Defaults.firstLevelSupportEmail
    }
}
