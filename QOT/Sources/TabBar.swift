//
//  TabBar.swift
//  QOT
//
//  Created by karmic on 21.09.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

enum TabBar: Index {
    case today = 0
    case learn = 1
    case data = 2
    case tbv = 3
    case prepare = 4

    var index: Index {
       return self.rawValue
    }

    var title: String {
        switch self {
        case .today: return R.string.localized.tabBarItemToday()
        case .learn: return R.string.localized.tabBarItemLearn()
        case .data: return R.string.localized.tabBarItemData()
        case .tbv: return R.string.localized.tabBarItemTbv()
        case .prepare: return R.string.localized.tabBarItemPrepare()
        }
    }

    var image: UIImage? {
        switch self {
        case .today: return R.image.shortcutItemTools()
        case .learn: return R.image.shortcutItemWhatsHotArticle()
        case .data: return R.image.shortcutItemMyData()
        case .tbv: return R.image.shortcutItemMyToBeVision()
        case .prepare: return R.image.shortcutItemPrepare()
        }
    }

    var itemConfig: TabBarItem.Config {
        var config = TabBarItem.Config.default
        config.title = title
        config.tag = index
        config.image = image
        config.selectedImage = image
        return config
    }
}
