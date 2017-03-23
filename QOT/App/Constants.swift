//  Constants.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

struct Animation {
    static let durationFade: TimeInterval = 0.4
    static let fadeInHeight: CGFloat = -22
    static let fadeOutHeight: CGFloat = 22
}

enum FontName: String {
    case simple = "Simple-Regular"
    case bentonBook = "BentonSans-Book"
    case bentonRegular = "BentonSans"
}

struct Layout {
    enum CellHeight: CGFloat {
        case sidebar = 75
        case sidebarSmall = 65
        case sidebarHeader = 50
    }
}

struct Databsase {
    enum Key: String {
        case primary = "id"
        case sort = "sort"
    }
}
