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
        case contactSupport
        case contactSupportNovartis
        case featureRequest

        static var supportValues: [MyQotSupportModelItem] {
            #if DEBUG_NOVARTIS || RELEASE_NOVARTIS
                return [.usingQOT, .faq, .contactSupportNovartis, .featureRequest]
            #else
                return [.usingQOT, .faq, .contactSupport, .featureRequest]
            #endif
        }

        func tag() -> Tags {
            switch self {
            case .usingQOT:
                return Tags.SupportUsingQOT
            case .faq:
                return Tags.SupportFaq
            case .contactSupport:
                return Tags.SupportContactSupport
            case .contactSupportNovartis:
                return Tags.SupportContactSupportNovartis
            case .featureRequest:
                return Tags.SupportFeatureRequest
            }
        }

        func tagSubtitle() -> Tags {
            switch self {
            case .usingQOT:
                return Tags.SupportLearnHowToUseQot
            case .faq:
                return Tags.SupportCheckTheMostAskedQuestion
            case .contactSupport, .contactSupportNovartis:
                return Tags.SupportContactUsForAnyQuestion
            case .featureRequest:
                return Tags.SupportAreYouMissingSomething
            }
        }

        func trackingKeys() -> String {
            return tag().rawValue
        }

        func title(for contentService: ContentService) -> String {
            return ScreenTitleService.main.localizedString(for: tag())
        }

        func subtitle(for contentService: ContentService) -> String {
            return ScreenTitleService.main.localizedString(for: tagSubtitle())
        }
    }
}
