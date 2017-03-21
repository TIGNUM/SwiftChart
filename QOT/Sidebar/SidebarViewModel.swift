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
    
    static var allCases: [SidebarCellType]  {
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
