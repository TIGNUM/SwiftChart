//
//  MyQotAboutUsModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct MyQotAboutUsModel {

    enum MyQotAboutUsModelItem: Int, CaseIterable {
        case about = 0
        case benefits
        case copyright
        case privacy
        case terms

        var primaryKey: Int {
            switch self {
            case .benefits: return 102364
            case .about: return 102363
            case .privacy: return 102360
            case .terms: return 102361
            case .copyright: return 102362
            }
        }

        static var allKeys: [Int] {
            return [MyQotAboutUsModelItem.about.primaryKey,
                    MyQotAboutUsModelItem.benefits.primaryKey,
                    MyQotAboutUsModelItem.copyright.primaryKey,
                    MyQotAboutUsModelItem.privacy.primaryKey,
                    MyQotAboutUsModelItem.terms.primaryKey
                   ]
        }

        func trackingKeys() -> String {
            switch self {
            case .benefits:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_about_qot)
            case .about:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_about_tignum)
            case .privacy:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_privacy_policy)
            case .terms:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_terms_and_conditions)
            case .copyright:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_content_and_copyright)
            }
        }

        func title(for contentService: qot_dal.ContentService) -> String {
            switch self {
            case .benefits:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_section_about_qot_title)
            case .about:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_section_about_tignum_title)
            case .privacy:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_section_privacy_title)
            case .terms:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_section_terms_and_conditions_title)
            case .copyright:
                return AppTextService.get(AppTextKey.my_qot_my_profile_about_us_section_copyright_title)
            }
        }

        func contentCollection(for contentService: qot_dal.ContentService,
                               _ completion: @escaping(QDMContentCollection?) -> Void) {
            switch self {
            case .benefits:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            case .about:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            case .privacy:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            case .terms:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            case .copyright:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            }
        }
    }
}
