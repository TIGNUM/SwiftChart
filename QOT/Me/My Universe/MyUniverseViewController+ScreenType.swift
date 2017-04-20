//
//  MyUniverseViewController+ScreenType.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension MyUniverseViewController {

    enum ScreenSize: CGFloat {
        case bigScreenHeight = 672
        case bigScreenWidth = 414
        case mediumScreenHeight = 603
        case mediumScreenWidth = 375
        case smallScreenHeight = 504
        case smallScreenWidth = 320
    }

    /// 6+ && 7+ are big screens
    /// medium 6 && 7
    /// 5 && SE are small
    enum ScreenType {
        case big
        case medium
        case small
    }

    var screenType: ScreenType {
        if isBig == true {
            return .big
        }

        if isMedium == true {
            return .medium
        }

        return .small
    }

    var isBig: Bool {
        if isPortrait == true {
            return height == ScreenSize.bigScreenHeight.rawValue
        }

        return width == ScreenSize.bigScreenWidth.rawValue
    }

    var isMedium: Bool {
        if isPortrait == true {
            return height == ScreenSize.mediumScreenHeight.rawValue
        }

        return width == ScreenSize.mediumScreenWidth.rawValue
    }

    var isSmall: Bool {
        if isPortrait == true {
            return height == ScreenSize.smallScreenHeight.rawValue
        }

        return width == ScreenSize.smallScreenWidth.rawValue
    }

    var size: CGSize {
        return view.bounds.size
    }

    var width: CGFloat {
        return size.width
    }

    var height: CGFloat {
        return size.height
    }
    
    var isPortrait: Bool {
        return height > width
    }
}
