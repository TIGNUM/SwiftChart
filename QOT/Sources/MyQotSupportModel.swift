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

        func tag() -> Tags {
            switch self {
            case .contactSupport:
                return Tags.SupportContactSupport
            case .featureRequest:
                return Tags.SupportFeatureRequest
            case .tutorial:
                return Tags.SupportTutorial
            case .faq:
                return Tags.SupportFaq
            }
        }

        func tagSubtitle() -> Tags {
            switch self {
            case .contactSupport:
                return Tags.SupportAreYouMissingSomething
            case .featureRequest:
                return Tags.SupportLearnHowToUseQot
            case .tutorial:
                return Tags.SupportContactUsForAnyQuestion
            case .faq:
                return Tags.SupportCheckTheMostAskedQuestion
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
