//
//  SidebarContentCategory.swift
//  QOT
//
//  Created by karmic on 16.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// Encapsulates data to display in a `LearnCategoryListViewController`.
protocol SidebarContentCategory: TrackableEntity {

    var localID: String { get }

    var title: String { get }

    var itemCount: Int { get }

    var font: UIFont { get }

    var cellHeight: CGFloat { get }

    var textColor: UIColor { get }

    var sidebarContentCollection: DataProvider<SidebarContentCollection> { get }

    var sidebarLayoutInfo: SidebarLayoutInfo { get }

    var keypathID: String? { get }
}

extension ContentCategory: SidebarContentCategory {

    var textColor: UIColor {
        return sidebarLayoutInfo.textColor
    }

    var cellHeight: CGFloat {
        return sidebarLayoutInfo.cellHeight
    }

    var font: UIFont {
        return sidebarLayoutInfo.font
    }

    var sidebarLayoutInfo: SidebarLayoutInfo {
        do {
            return try getSidebarLayoutInfo()
        } catch let error {
            fatalError("sidebarLayoutInfo \(error)")
        }
    }

    var sidebarContentCollection: DataProvider<SidebarContentCollection> {
        return DataProvider(list: contentCollections, map: { $0 as SidebarContentCollection })
    }
}

