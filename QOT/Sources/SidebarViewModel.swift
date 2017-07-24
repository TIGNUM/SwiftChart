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
        case library = 0
        case benefits
        case settings
        case sensor
        case about
        case privacy
        case logout

        static var allValues: [SidebbarItem] {
            return [
                .library,
                .benefits,
                .settings,
                .sensor,
                .about,
                .privacy,
                .logout
            ]
        }

        var title: String {
            switch self {
            case .library: return R.string.localized.sidebarTitleLibrary()
            case .benefits: return R.string.localized.sidebarTitleBenefits()
            case .settings: return R.string.localized.sidebarTitleSettings()
            case .sensor: return R.string.localized.sidebarTitleSensor()
            case .about: return R.string.localized.sidebarTitleAbout()
            case .privacy: return R.string.localized.sidebarTitlePrivacy()
            case .logout: return R.string.localized.sidebarTitleLogout()
            }
        }

        var font: UIFont {
            switch self {
            case .library: return Font.H2SecondaryTitle
            case .benefits: return Font.H2SecondaryTitle
            case .settings: return Font.H2SecondaryTitle
            case .sensor: return Font.H2SecondaryTitle
            case .about: return Font.H5SecondaryHeadline
            case .privacy: return Font.H5SecondaryHeadline
            case .logout: return Font.H5SecondaryHeadline
            }
        }

        var fontColor: UIColor {
            switch self {
            case .library: return .white
            case .benefits: return .white
            case .settings: return .white
            case .sensor: return .white
            case .about: return .white40
            case .privacy: return .white40
            case .logout: return .white40
            }
        }

        func cellHeight(screenType: UIViewController.ScreenType) -> CGFloat {
            switch self {
            case .library:
                switch screenType {
                case .big: return 180
                case .medium: return 140
                case .small: return 100
                }
            case .benefits: return 80
            case .settings: return 80
            case .sensor: return 80
            case .about:
                switch screenType {
                case .big: return 100
                case .medium: return 80
                case .small: return 65
                }
            case .privacy: return 65
            case .logout: return 65
            }
        }

        func topAnchor(screenType: UIViewController.ScreenType) -> CGFloat {
            switch self {
            case .library:
                switch screenType {
                case .big: return 100
                case .medium: return 60
                case .small: return 20
                }
            case .benefits: return 0
            case .settings: return 0
            case .sensor: return 0
            case .about:
                switch screenType {
                case .big: return 35
                case .medium: return 15
                case .small: return 0
                }
            case .privacy: return 0
            case .logout: return 0
            }
        }

        var primaryKey: Int {
            switch self {
            case .library: return 0
            case .benefits: return 100101
            case .settings: return 0
            case .sensor: return 0
            case .about: return 100092
            case .privacy: return 100100
            case .logout: return 0
            }
        }

        func contentCollection(for service: ContentService) -> ContentCollection? {
            switch self {
            case .library: return nil
            case .benefits: return service.contentCollection(id: primaryKey)
            case .settings: return nil
            case .sensor: return nil
            case .about: return service.contentCollection(id: primaryKey)
            case .privacy: return service.contentCollection(id: primaryKey)
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
