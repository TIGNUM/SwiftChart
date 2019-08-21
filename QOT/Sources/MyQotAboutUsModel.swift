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

        func trackingKeys() -> String {
            switch self {
            case .benefits:
                return qot_dal.ContentService.AboutUs.qotBenefits.rawValue
            case .about:
                return qot_dal.ContentService.AboutUs.aboutTignum.rawValue
            case .privacy:
                return qot_dal.ContentService.AboutUs.privacy.rawValue
            case .terms:
                return qot_dal.ContentService.AboutUs.termsAndConditions.rawValue
            case .copyright:
                return qot_dal.ContentService.AboutUs.copyright.rawValue
            }
        }

        func title(for contentService: qot_dal.ContentService, _ completion: @escaping(String) -> Void) {
            switch self {
            case .benefits:
                contentService.getContentItemsByPredicate(
                qot_dal.ContentService.AboutUs.qotBenefits.predicate) {(contentItems) in
                    completion(contentItems?.last?.valueText ?? "")
                }
            case .about:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.aboutTignum.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .privacy:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.privacy.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .terms:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.termsAndConditions.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .copyright:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.copyright.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            }
        }

        func subtitle(for contentService: qot_dal.ContentService, _ completion: @escaping(String) -> Void) {
            switch self {
            case .benefits:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.qotBenefitsSubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .about:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.aboutTignumSubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .privacy:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.privacySubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .terms:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.termsAndCOnditionSubtitle.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .copyright:
                contentService.getContentItemByPredicate(
                qot_dal.ContentService.AboutUs.contentAndCopyrightSubtitle.predicate) {(contentItem) in
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
