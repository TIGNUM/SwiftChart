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
    case me = 2
    case prepare = 3

    var index: Index {
       return self.rawValue
    }

    var title: String {
        switch self {
        case .guide: return R.string.localized.tabBarItemGuide()
        case .learn: return R.string.localized.tabBarItemLearn()
        case .me: return R.string.localized.tabBarItemMe()
        case .prepare: return R.string.localized.tabBarItemPrepare()
        }
    }

    var itemConfig: TabBarItem.Config {
        var config = TabBarItem.Config.default
        config.title = title
        config.tag = index
        return config
    }
}
