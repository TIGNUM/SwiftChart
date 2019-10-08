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
                    MyQotAboutUsModelItem.terms.primaryKey,
                   ]
        }

        func tag() -> Tags {
            switch self {
            case .benefits:
                return .AboutUsQotBenefits
            case .about:
                return .AboutUsAboutTignum
            case .privacy:
                return .AboutUsPrivacy
            case .terms:
                return .AboutUsTermsAndConditions
            case .copyright:
                return .AboutUsCopyright
            }
        }

        func tagSubtitle() -> Tags {
            switch self {
            case .benefits:
                return .AboutUsQotBenefitsSubtitle
            case .about:
                return .AboutUsAboutTignumSubtitle
            case .privacy:
                return .AboutUsPrivacySubtitle
            case .terms:
                return .AboutUsTermsAndConditionSubtitle
            case .copyright:
                return .AboutUsContentAndCopyrightSubtitle
            }
        }

        func trackingKeys() -> String {
            return tag().rawValue
        }

        func title(for contentService: qot_dal.ContentService) -> String {
            return ScreenTitleService.main.localizedString(for: tag())
        }

        func subtitle(for contentService: qot_dal.ContentService) -> String {
            return ScreenTitleService.main.localizedString(for: tagSubtitle())
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
