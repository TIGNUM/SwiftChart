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

    enum MyQotAboutUsModelItem: Int {
        case benefits
        case about
        case privacy
        case terms
        case copyright

        static var aboutValues: [MyQotAboutUsModelItem] {
            return [.copyright, .about, .privacy, .terms, .benefits ]
        }

        var primaryKey: Int {
            switch self {
            case .benefits: return 100101
            case .about: return 100092
            case .privacy: return 100163
            case .terms: return 100102
            case .copyright: return 100105
            }
        }

        func trackingKeys() -> String {
            switch self {
            case .benefits:
                return ContentService.AboutUs.qotBenefits.rawValue
            case .about:
                return ContentService.AboutUs.aboutTignum.rawValue
            case .privacy:
                return ContentService.AboutUs.privacy.rawValue
            case .terms:
                return ContentService.AboutUs.termsAndConditions.rawValue
            case .copyright:
                return ContentService.AboutUs.copyright.rawValue
            }
        }

        func title(for contentService: qot_dal.ContentService, _ completion: @escaping(String) -> Void) {
            switch self {
            case .benefits:
                contentService.getContentItemByPredicate(ContentService.AboutUs.qotBenefits.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .about:
                contentService.getContentItemByPredicate(ContentService.AboutUs.aboutTignum.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .privacy:
                contentService.getContentItemByPredicate(ContentService.AboutUs.privacy.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .terms:
                contentService.getContentItemByPredicate(ContentService.AboutUs.termsAndConditions.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .copyright:
                contentService.getContentItemByPredicate(ContentService.AboutUs.copyright.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            }
        }

        func subtitle(for contentService: qot_dal.ContentService, _ completion: @escaping(String) -> Void) {
            switch self {
            case .benefits:
                contentService.getContentItemByPredicate(ContentService.AboutUs.qotBenefitsSubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .about:
                contentService.getContentItemByPredicate(ContentService.AboutUs.aboutTignumSubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .privacy:
                contentService.getContentItemByPredicate(ContentService.AboutUs.privacySubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .terms:
                contentService.getContentItemByPredicate(ContentService.AboutUs.termsAndCOnditionSubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .copyright:
                contentService.getContentItemByPredicate(ContentService.AboutUs.contentAndCopyrightSubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            }
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

        func contentCollection(for contentService: qot_dal.ContentService, _ completion: @escaping(QDMContentCollection?) -> Void) {
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
