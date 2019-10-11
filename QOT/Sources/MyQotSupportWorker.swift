//
//  MyQotSupportWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSupportWorker {

    private let contentService: qot_dal.ContentService
    private let userService: qot_dal.UserService

    init(contentService: qot_dal.ContentService, userService: qot_dal.UserService) {
        self.contentService = contentService
        self.userService = userService
    }

    func itemCount() -> Int {
        return MyQotSupportModel.MyQotSupportModelItem.supportValues.count
    }

    func item(at indexPath: IndexPath) -> MyQotSupportModel.MyQotSupportModelItem? {
        return MyQotSupportModel.MyQotSupportModelItem(rawValue: indexPath.row)
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.trackingKeys()
    }

    func title(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.title()
    }

    func subtitle(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem(rawValue: indexPath.row) else {
            return ""
        }
        return item.subtitle()
    }

    func contentCollection(_ item: MyQotSupportModel.MyQotSupportModelItem, _ completion: @escaping(QDMContentCollection?) -> Void) {
        item.contentCollection(for: contentService) { (collection) in
            completion(collection)
        }
    }

    var supportText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_support_title)
    }

    func email(_ completion: @escaping(String) -> Void) {
        userService.getUserData { (user) in
            guard let email = user?.firstLevelSupportEmail, !email.isEmpty else {
                completion(Defaults.firstLevelSupportEmail)
                return
            }
            completion(email)
        }
    }
}
