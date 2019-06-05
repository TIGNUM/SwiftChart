//
//  MyQotAboutUsModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

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

        func trackingKeys(for services: Services) -> String {
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

        func title(for services: Services) -> String {
            switch self {
            case .benefits:
                return services.contentService.localizedString(for: ContentService.AboutUs.qotBenefits.predicate) ?? ""
            case .about:
                return services.contentService.localizedString(for: ContentService.AboutUs.aboutTignum.predicate) ?? ""
            case .privacy:
                return services.contentService.localizedString(for: ContentService.AboutUs.privacy.predicate) ?? ""
            case .terms:
                return services.contentService.localizedString(for: ContentService.AboutUs.termsAndConditions.predicate) ?? ""
            case .copyright:
                return services.contentService.localizedString(for: ContentService.AboutUs.copyright.predicate) ?? ""
            }
        }

        func subtitle(for services: Services) -> String {
            switch self {
            case .benefits:
                return services.contentService.localizedString(for: ContentService.AboutUs.qotBenefitsSubtitle.predicate) ?? ""
            case .about:
                return services.contentService.localizedString(for: ContentService.AboutUs.aboutTignumSubtitle.predicate) ?? ""
            case .privacy:
                return services.contentService.localizedString(for: ContentService.AboutUs.privacySubtitle.predicate) ?? ""
            case .terms:
                return services.contentService.localizedString(for: ContentService.AboutUs.termsAndCOnditionSubtitle.predicate) ?? ""
            case .copyright:
                return services.contentService.localizedString(for: ContentService.AboutUs.contentAndCopyrightSubtitle.predicate) ?? ""
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

        func contentCollection(for service: ContentService) -> ContentCollection? {
            switch self {
            case .benefits: return service.contentCollection(id: primaryKey)
            case .about: return service.contentCollection(id: primaryKey)
            case .privacy: return service.contentCollection(id: primaryKey)
            case .terms: return service.contentCollection(id: primaryKey)
            case .copyright: return service.contentCollection(id: primaryKey)
            }
        }
    }
}
