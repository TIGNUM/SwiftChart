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

    enum Sidebbar: Int {
        case library = 0
        case benefits
        case settings
        case sensor
        case about
        case privacy
        case logout

        static var allValues: [Sidebbar] {
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

        var cellHeight: CGFloat {
            switch self {
            case .library: return 75
            case .benefits: return 75
            case .settings: return 75
            case .sensor: return 75
            case .about: return 65
            case .privacy: return 65
            case .logout: return 65
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
    }

    // MARK: - Properties

    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    var itemCount: Int {        
        return Sidebbar.allValues.count
    }

    func sidebarItem(at indexPath: IndexPath) -> Sidebbar? {
        return Sidebbar(rawValue: indexPath.row)
    }
}
