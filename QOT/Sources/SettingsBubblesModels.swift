//
//  SettingsBubblesModels.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit
import RealmSwift

enum SettingsBubblesType {
    case about
    case support
}

final class SettingsBubblesModel {

    enum SettingsBubblesItem: Int {
        case benefits
        case about
        case privacy
        case terms
        case copyright
        case contactSupport
        case featureRequest
        case tutorial
        case faq

        static var aboutValues: [SettingsBubblesItem] {
            return [.benefits, .about, .privacy, .terms, .copyright]
        }

        static var supportValues: [SettingsBubblesItem] {
            return [.contactSupport, .featureRequest, .tutorial, .faq]
        }

        var primaryKey: Int {
            switch self {
            case .benefits: return 100101
            case .about: return 100092
            case .privacy: return 100163
            case .terms: return 100102
            case .copyright: return 100105
            case .contactSupport: return 101192
            case .featureRequest,
                 .tutorial: return 0
            case .faq: return 100704

            }
        }

        var title: String {
            switch self {
            case .benefits: return R.string.localized.sidebarTitleBenefits()
            case .about: return R.string.localized.sidebarTitleAbout()
            case .privacy: return R.string.localized.settingsSecurityPrivacyPolicyTitle()
            case .terms: return R.string.localized.settingsSecurityTermsTitle()
            case .copyright: return R.string.localized.settingsSecurityCopyrightsTitle()
            case .contactSupport: return R.string.localized.sidebarTitleContactSupport()
            case .featureRequest: return R.string.localized.sidebarTitleFeatureRequest()
            case .tutorial: return R.string.localized.settingsGeneralTutorialTitle()
            case .faq: return R.string.localized.sidebarTitleFAQ()
            }
        }

        var pageName: PageName {
            switch self {
            case .benefits: return .benefits
            case .about: return .about
            case .privacy: return .privacy
            case .terms: return .terms
            case .copyright: return .copyrights
            case .contactSupport: return .supportContact
            case .featureRequest: return .featureRequest
            case .tutorial: return .tutorial
            case .faq: return .faq
            }
        }

        func contentCollection(for service: ContentService) -> ContentCollection? {
            switch self {
            case .contactSupport: return service.contentCollection(id: primaryKey)
            case .featureRequest,
                 .tutorial: return nil
            case .benefits: return service.contentCollection(id: primaryKey)
            case .about: return service.contentCollection(id: primaryKey)
            case .privacy: return service.contentCollection(id: primaryKey)
            case .faq: return service.contentCollection(id: primaryKey)
            case .terms: return service.contentCollection(id: primaryKey)
            case .copyright: return service.contentCollection(id: primaryKey)
            }
        }
    }
}
