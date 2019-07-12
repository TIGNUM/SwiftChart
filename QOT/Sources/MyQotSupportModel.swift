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
        case featureRequest
        case tutorial
        case contactSupport
        case faq

        static var supportValues: [MyQotSupportModelItem] {
            return [.featureRequest, .tutorial, .contactSupport, .faq]
        }

        var primaryKey: Int {
            switch self {
            case .contactSupport: return 101192
            case .featureRequest,
                 .tutorial: return 0
            case .faq: return 100704
            }
        }

        func trackingKeys() -> String {
            switch self {
            case .contactSupport:
                return ContentService.Support.contactSupport.rawValue
            case .featureRequest:
                return ContentService.Support.featureRequest.rawValue
            case .tutorial:
                return ContentService.Support.tutorial.rawValue
            case .faq:
                return ContentService.Support.faq.rawValue
            }
        }

        func title(for contentService: qot_dal.ContentService, _ completion: @escaping(String) -> Void) {
            switch self {
            case .contactSupport:
                contentService.getContentItemByPredicate(ContentService.Support.contactSupport.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .featureRequest:
                contentService.getContentItemByPredicate(ContentService.Support.featureRequest.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .tutorial:
                contentService.getContentItemByPredicate(ContentService.Support.tutorial.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .faq:
                contentService.getContentItemByPredicate(ContentService.Support.faq.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            }
        }

        func subtitle(for contentService: qot_dal.ContentService, _ completion: @escaping(String) -> Void) {
            switch self {
            case .contactSupport:
                contentService.getContentItemByPredicate(ContentService.Support.areYouMissingSomething.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .featureRequest:
                contentService.getContentItemByPredicate(ContentService.Support.learnHowToUseQot.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .tutorial:
                contentService.getContentItemByPredicate(ContentService.Support.contactUsForAnyQuestion.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            case .faq:
                contentService.getContentItemByPredicate(ContentService.Support.checkTheMostAskedQuestion.predicate) {(contentItem) in
                    completion(contentItem?.valueText ?? "")
                }
            }
        }

        var pageName: PageName {
            switch self {
            case .contactSupport: return .supportContact
            case .featureRequest: return .featureRequest
            case .tutorial: return .tutorial
            case .faq: return .faq
            }
        }

        func contentCollection(for contentService: qot_dal.ContentService, completion: @escaping(QDMContentCollection?) -> Void) {
            switch self {
            case .contactSupport:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            case .featureRequest, .tutorial:
                 completion(nil)
            case .faq:
                contentService.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            }
        }
    }
}
