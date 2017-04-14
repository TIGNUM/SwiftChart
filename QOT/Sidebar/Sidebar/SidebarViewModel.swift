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
    case about
    case privacy
    case logout
    
    static var allCases: [SidebarCellType] {
        return [
            SidebarCellType.library,
            SidebarCellType.benefits,
            SidebarCellType.settings,
            SidebarCellType.sensor,
            SidebarCellType.about,
            SidebarCellType.privacy,
            SidebarCellType.logout
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
    
    var textColor: UIColor {
        switch self {
        case .library: return Color.Default.white
        case .benefits: return Color.Default.white
        case .settings: return Color.Default.white
        case .sensor: return Color.Default.white
        case .about: return Color.Default.whiteMedium
        case .privacy: return Color.Default.whiteMedium
        case .logout: return Color.Default.whiteMedium
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .library: return Layout.CellHeight.sidebar.rawValue
        case .benefits: return Layout.CellHeight.sidebar.rawValue
        case .settings: return Layout.CellHeight.sidebar.rawValue
        case .sensor: return Layout.CellHeight.sidebar.rawValue
        case .about: return Layout.CellHeight.sidebarSmall.rawValue
        case .privacy: return Layout.CellHeight.sidebarSmall.rawValue
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
