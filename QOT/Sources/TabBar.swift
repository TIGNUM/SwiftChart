//
//  TabBar.swift
//  QOT
//
//  Created by karmic on 21.09.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

enum TabBar: Index {
    case guide = 0
    case learn = 1
    case tbv = 2
    case data = 3
    case prepare = 4

    var index: Index {
       return self.rawValue
    }

    var title: String {
        switch self {
        case .guide: return R.string.localized.tabBarItemGuide()
        case .learn: return R.string.localized.tabBarItemLearn()
        case .data: return R.string.localized.tabBarItemData()
        case .tbv: return R.string.localized.tabBarItemTbv()
        case .prepare: return R.string.localized.tabBarItemPrepare()
        }
    }

    var image: UIImage? {
        switch self {
        case .guide: return R.image.tabBarItemCompassRose()
        case .learn: return R.image.tabBarItemLearn()
        case .data: return R.image.tabBarItemCharts()
        case .tbv: return R.image.tabBarItemTignum()
        case .prepare: return R.image.tabBarItemCalendar()
        }
    }

    var itemConfig: TabBarItem.Config {
        var config = TabBarItem.Config.default
        config.tag = index
        config.image = image
        config.title = title
        return config
    }
}
