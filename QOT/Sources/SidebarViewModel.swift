//
//  SidebarViewModel.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class SidebarViewModel {

    enum SidebbarItem: Int {
        case search = 0
        case tools
        case settings
        case sensor
        case placeholder
        case benefits
        case introSliders
        case about
        case faq
        case privacy

        static var allValues: [SidebbarItem] {
            return [.search,
                    .tools,
                    .settings,
                    .sensor,
                    .placeholder,
                    .benefits,
                    .introSliders,
                    .about,
                    .privacy,
                    .faq]
        }

        var title: String? {
            switch self {
            case .search: return R.string.localized.sidebarTitleSearch()
            case .tools: return R.string.localized.sidebarTitleTools()
            case .benefits: return R.string.localized.sidebarTitleBenefits()
            case .settings: return R.string.localized.sidebarTitleSettings()
            case .sensor: return R.string.localized.sidebarTitleSensor()
            case .placeholder: return nil
            case .about: return R.string.localized.sidebarTitleAbout()
            case .introSliders: return R.string.localized.sidebarTitleIntroSliders()
            case .privacy: return R.string.localized.settingsSecurityPrivacyPolicyTitle()
            case .faq: return R.string.localized.sidebarTitleFAQ()
            }
        }

        var backgroundImage: UIImage? {
            switch self {
            case .benefits, .privacy: return R.image.sidebar()
            default: return nil
            }
        }

        func font(screenType: UIViewController.ScreenType) -> UIFont? {
            switch self {
            case .search,
                 .tools,
                 .settings,
                 .sensor: return screenType == .small ? Font.H3Subtitle : Font.H2SecondaryTitle
            case .placeholder: return nil
            case .about,
                 .privacy,
                 .benefits,
                 .introSliders,
                 .faq: return screenType == .small ? Font.H6NavigationTitle : Font.H5SecondaryHeadline
            }
        }

        var fontColor: UIColor? {
            switch self {
            case .search,
                 .tools,
                 .settings,
                 .sensor: return .white
            case .placeholder: return nil
            case .about,
                 .privacy,
                 .benefits,
                 .introSliders,
                 .faq: return .white40
            }
        }

        func cellHeight(screenType: UIViewController.ScreenType) -> CGFloat {
            switch self {
            case .search,
                 .tools,
                 .settings,
                 .sensor: return screenType == .small ? 60 : screenType == .medium ? 70 : 80
            case .placeholder: return 40
            case .about,
                 .privacy,
                 .benefits,
                 .introSliders,
                 .faq: return screenType == .small ? 50 : screenType == .medium ? 60 : 70
            }
        }

        var primaryKey: Int {
            switch self {
            case .search: return 0
            case .tools: return 0
            case .benefits: return 100101
            case .settings: return 0
            case .sensor: return 100935
            case .placeholder: return 0
            case .about: return 100092
            case .privacy: return 100163
            case .faq: return 100704
            case .introSliders: return 0
            }
        }

        func contentCollection(for service: ContentService) -> ContentCollection? {
            switch self {
            case .search: return nil
            case .tools: return nil
            case .benefits: return service.contentCollection(id: primaryKey)
            case .settings: return nil
            case .sensor: return service.contentCollection(id: primaryKey)
            case .placeholder: return nil
            case .about: return service.contentCollection(id: primaryKey)
            case .privacy: return service.contentCollection(id: primaryKey)
            case .faq: return service.contentCollection(id: primaryKey)
            case .introSliders: return nil
            }
        }
    }

    // MARK: - Properties

    let updates = PublishSubject<CollectionUpdate, NoError>()
    let services: Services

    init(services: Services) {
        self.services = services
    }

    var itemCount: Int {
        return SidebbarItem.allValues.count
    }

    func sidebarItem(at indexPath: IndexPath) -> SidebbarItem? {
        return SidebbarItem(rawValue: indexPath.row)
    }

    func contentCollection(_ sidebarItem: SidebbarItem) -> ContentCollection? {
        return sidebarItem.contentCollection(for: services.contentService)
    }
}
