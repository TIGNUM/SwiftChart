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
        case sensor
        case profile
        case placeholder
        case support
        case about
        case logout

        static var allValues: [SidebbarItem] {
            return [.search, .tools, .sensor, .profile, .placeholder, .support, .about, .logout]
        }

        var title: String? {
            switch self {
            case .search: return R.string.localized.sidebarTitleSearch()
            case .tools: return R.string.localized.sidebarTitleTools()
            case .profile: return R.string.localized.sidebarTitleProfile()
            case .sensor: return R.string.localized.sidebarTitleSensor()
            case .placeholder: return nil
            case .support: return R.string.localized.sidebarTitleSupport()
            case .about: return R.string.localized.sidebarTitleAbout()
            case .logout: return R.string.localized.sidebarTitleLogout()
            }
        }

        func font(screenType: UIViewController.ScreenType) -> UIFont? {
            switch self {
            case .search,
                 .tools,
                 .profile,
                 .sensor: return screenType == .small ? Font.H3Subtitle : Font.H2SecondaryTitle
            case .placeholder: return nil
            case .support,
                 .about,
                 .logout: return screenType == .small ? Font.H6NavigationTitle : Font.H5SecondaryHeadline
            }
        }

        var fontColor: UIColor? {
            switch self {
            case .search,
                 .tools,
                 .profile,
                 .sensor: return .white
            case .placeholder: return nil
            case .support,
                 .about,
                 .logout: return .white40
            }
        }

        func cellHeight(screenType: UIViewController.ScreenType) -> CGFloat {
            switch self {
            case .search,
                 .tools,
                 .profile,
                 .sensor: return screenType == .small ? 60 : screenType == .medium ? 70 : 80
            case .placeholder: return 40
            case .support,
                 .about,
                 .logout: return screenType == .small ? 50 : screenType == .medium ? 60 : 70
            }
        }

        var primaryKey: Int {
            switch self {
            case .search: return 0
            case .tools: return 0
            case .profile: return 0
            case .sensor: return 100935
            case .placeholder: return 0
            case .support: return 0
            case .about: return 100092
            case .logout: return 0
            }
        }

        func contentCollection(for service: ContentService) -> ContentCollection? {
            switch self {
            case .search: return nil
            case .tools: return nil
            case .profile: return nil
            case .sensor: return service.contentCollection(id: primaryKey)
            case .placeholder: return nil
            case .support: return nil
            case .about: return service.contentCollection(id: primaryKey)
            case .logout: return nil
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
