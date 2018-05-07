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
        case profile = 0
        case tools
        case search
        case settings
        case admin
        case placeholder
        case support
        case about

        static var allValues: [SidebbarItem] {
            return [.profile, .tools, .search, .settings, .admin, .placeholder, .support, .about]
        }

        static var restrictedValues: [SidebbarItem] {
            return [.profile, .tools, .search, .settings, .placeholder, .support, .about]
        }

        var title: String? {
            switch self {
            case .search: return R.string.localized.sidebarTitleSearch()
            case .tools: return R.string.localized.sidebarTitleTools()
            case .profile: return R.string.localized.sidebarTitleProfile()
            case .settings: return R.string.localized.settingsTitle()
            case .admin: return R.string.localized.settingsGeneralAdminTitle()
            case .placeholder: return nil
            case .support: return R.string.localized.sidebarTitleSupport()
            case .about: return R.string.localized.sidebarTitleAbout()
            }
        }

        func font(screenType: UIViewController.ScreenType) -> UIFont? {
            switch self {
            case .search,
                 .tools,
                 .profile,
                 .settings,
                 .admin: return screenType == .small ? Font.H3Subtitle : Font.H2SecondaryTitle
            case .placeholder: return nil
            case .support,
                 .about: return screenType == .small ? Font.H6NavigationTitle : Font.H5SecondaryHeadline
            }
        }

        var fontColor: UIColor? {
            switch self {
            case .search,
                 .tools,
                 .profile,
                 .settings,
                 .admin: return .white
            case .placeholder: return nil
            case .support,
                 .about: return .white40
            }
        }

        func cellHeight(screenType: UIViewController.ScreenType) -> CGFloat {
            switch self {
            case .search,
                 .tools,
                 .profile,
                 .settings,
                 .admin: return screenType == .small ? 60 : screenType == .medium ? 70 : 80
            case .placeholder: return 40
            case .support,
                 .about: return screenType == .small ? 50 : screenType == .medium ? 60 : 70
            }
        }

        var primaryKey: Int {
            switch self {
            case .search: return 0
            case .tools: return 0
            case .profile: return 0
            case .settings: return 0
            case .admin: return 0
            case .placeholder: return 0
            case .support: return 0
            case .about: return 100092
            }
        }

        func contentCollection(for service: ContentService) -> ContentCollection? {
            switch self {
            case .search: return nil
            case .tools: return nil
            case .profile: return nil
            case .settings: return nil
            case .admin: return nil
            case .placeholder: return nil
            case .support: return nil
            case .about: return service.contentCollection(id: primaryKey)
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
        if services.settingsService.allowAdminSettings() == true {
            return SidebbarItem.allValues.count
        } else {
            return SidebbarItem.restrictedValues.count
        }
    }

    func sidebarItem(at indexPath: IndexPath) -> SidebbarItem? {
        if services.settingsService.allowAdminSettings() == true {
            return SidebbarItem.allValues.item(at: indexPath.row)
        } else {
            return SidebbarItem.restrictedValues.item(at: indexPath.row)
        }
    }

    func contentCollection(_ sidebarItem: SidebbarItem) -> ContentCollection? {
        return sidebarItem.contentCollection(for: services.contentService)
    }
}
