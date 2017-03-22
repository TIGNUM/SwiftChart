//
//  SidebarViewModel.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

enum SidebarCellType: Int {
    case library = 0
    case benefits
    case settings
    case sensor
    case privacy
    case about
    case logout
    
    static var allCases: [SidebarCellType] {
        return [
            SidebarCellType.library,
            SidebarCellType.benefits,
            SidebarCellType.settings,
            SidebarCellType.sensor,
            SidebarCellType.privacy,
            SidebarCellType.about,
            SidebarCellType.logout
        ]
    }
    
    var title: String {
        switch self {
        case .library: return R.string.localized.sidebarTitleLibrary()
        case .benefits: return R.string.localized.sidebarTitleBenefits()
        case .settings: return R.string.localized.sidebarTitleSettings()
        case .sensor: return R.string.localized.sidebarTitleSensor()
        case .privacy: return R.string.localized.sidebarTitlePrivacy()
        case .about: return R.string.localized.sidebarTitleAbout()
        case .logout: return R.string.localized.sidebarTitleLogout()
        }
    }
    
    var font: UIFont? {
        switch self {
        case .library: return .sidebar
        case .benefits: return .sidebar
        case .settings: return .sidebar
        case .sensor: return .sidebar
        case .privacy: return .sidebarSmall
        case .about: return .sidebarSmall
        case .logout: return .sidebarSmall
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .library: return .qotWhite
        case .benefits: return .qotWhite
        case .settings: return .qotWhite
        case .sensor: return .qotWhite
        case .privacy: return .qotWhiteMedium
        case .about: return .qotWhiteMedium
        case .logout: return .qotWhiteMedium
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .library: return Layout.CellHeight.sidebar.rawValue
        case .benefits: return Layout.CellHeight.sidebar.rawValue
        case .settings: return Layout.CellHeight.sidebar.rawValue
        case .sensor: return Layout.CellHeight.sidebar.rawValue
        case .privacy: return Layout.CellHeight.sidebarSmall.rawValue
        case .about: return Layout.CellHeight.sidebarSmall.rawValue
        case .logout: return Layout.CellHeight.sidebarSmall.rawValue
        }
    }
}

final class SidebarViewModel {
    
    private var sidebarItems = SidebarCellType.allCases
    
    var itemCount: Int {        
        return SidebarCellType.allCases.count
    }
    
    func item(at index: Index) -> SidebarCellType {
        return sidebarItems[index]
    }
}
