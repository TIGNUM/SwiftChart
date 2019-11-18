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

    private let contentService: ContentService
    private let userService: UserService

    init(contentService: ContentService, userService: UserService) {
        self.contentService = contentService
        self.userService = userService
    }

    func itemCount() -> Int {
        return MyQotSupportModel.MyQotSupportModelItem.supportValues.count
    }

    func item(at indexPath: IndexPath) -> MyQotSupportModel.MyQotSupportModelItem? {
        return MyQotSupportModel.MyQotSupportModelItem.supportValues[indexPath.row]
    }

    func trackingKeys(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem.supportValues.at(index: indexPath.row) else {
            return ""
        }
        return item.trackingKeys()
    }

    func title(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem.supportValues.at(index: indexPath.row) else {
            return ""
        }
        return item.title()
    }

    func subtitle(at indexPath: IndexPath) -> String {
        guard let item = MyQotSupportModel.MyQotSupportModelItem.supportValues.at(index: indexPath.row) else {
            return ""
        }
        return item.subtitle()
    }

    var supportText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_support_section_feature_request_title)
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

    func supportNovartis(collectionId: Int, _ completion: @escaping(String?, String?) -> Void) {
        contentService.getContentCollectionById(collectionId) { (qdmContentCollection) in
            completion(qdmContentCollection?.contentItems.first?.valueText,
                       qdmContentCollection?.contentItems.last?.valueText)
        }
    }
}
