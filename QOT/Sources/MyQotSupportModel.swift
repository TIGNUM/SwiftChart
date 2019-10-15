//
//  MyQotSupportModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct MyQotSupportModel {

    enum MyQotSupportModelItem: Int {
        case usingQOT
        case faq
        case reportIssue
        case featureRequest

        static var supportValues: [MyQotSupportModelItem] {
            return [.usingQOT, .faq, .reportIssue, .featureRequest]
        }

        var primaryKey: Int {
            switch self {
            case .usingQOT: return 101192
            case .faq: return 100704
            case .reportIssue: return 0
            case .featureRequest: return 0
            }
        }

        func tag() -> Tags {
            switch self {
            case .usingQOT:
                return Tags.SupportUsingQOT
            case .faq:
                return Tags.SupportFaq
            case .reportIssue:
                return Tags.SupportContactSupport
            case .featureRequest:
                return Tags.SupportFeatureRequest
            }
        }

        func trackingKeys() -> String {
            return tag().rawValue
        }

        func title() -> String {
            switch self {
            case .usingQOT:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_title_feature)
            case .faq:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_title_faq)
            case .reportIssue:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_title_tutorial)
            case .featureRequest:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_title_support)
            }
        }

        func subtitle() -> String {
            switch self {
            case .usingQOT:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_subtitle_feature)
            case .faq:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_subtitle_faq)
            case .reportIssue:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_subtitle_tutorial)
            case .featureRequest:
                return AppTextService.get(AppTextKey.my_qot_my_profile_support_view_subtitle_support)
            }
        }

        func contentCollection(for contentService: qot_dal.ContentService, completion: @escaping(QDMContentCollection?) -> Void) {
            switch self {
            case .usingQOT:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            case .faq:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            case .reportIssue:
                completion(nil)
            case .featureRequest:
                completion(nil)
            }

        }
    }
}
