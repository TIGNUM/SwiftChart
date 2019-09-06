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
        case benefits = 0
        case about
        case privacy
        case terms
        case copyright

        var primaryKey: Int {
            switch self {
            case .benefits: return 100101
            case .about: return 100092
            case .privacy: return 100163
            case .terms: return 100102
            case .copyright: return 100105
            }
        }

        static var allKeys: [Int] {
            return [MyQotAboutUsModelItem.benefits.primaryKey,
                    MyQotAboutUsModelItem.about.primaryKey,
                    MyQotAboutUsModelItem.privacy.primaryKey,
                    MyQotAboutUsModelItem.terms.primaryKey,
                    MyQotAboutUsModelItem.copyright.primaryKey]
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

        var pageName: PageName {
            switch self {
            case .benefits: return .benefits
            case .about: return .about
            case .privacy: return .privacy
            case .terms: return .terms
            case .copyright: return .copyrights
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
