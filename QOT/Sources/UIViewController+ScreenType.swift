//
//  UIViewController+ScreenType.swift
//  QOT
//
//  Created by karmic on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    private enum ScreenSize: CGFloat {
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

        var lineSpacingSectorTitle: CGFloat {
            switch self {
            case .big: return 2
            case .medium: return 1.8
            case .small: return 1.6
            }
        }

        var lineSpacingSectorTitleCritical: CGFloat {
            switch self {
            case .big: return 2.7
            case .medium: return 2.5
            case .small: return 2.3
            }
        }

        var fontCritical: UIFont {
            switch self {
            case .big: return Font.PText
            case .medium,
                 .small: return Font.PTextSmall
            }
        }

        var countLabelLeadingAnchorOffset: CGFloat {
            switch self {
            case .big: return 28
            case .medium: return 20
            case .small: return 16
            }
        }

        var countLabelTopCenterAnchorOffset: CGFloat {
            switch self {
            case .big: return 60
            case .medium: return 50
            case .small: return 40
            }
        }

        var countLabelTopAnchorOffset: CGFloat {
            switch self {
            case .big: return 50
            case .medium: return 40
            case .small: return 30
            }
        }

        var contentCenterXAnchorOffset: CGFloat {
            switch self {
            case .big: return 28
            case .medium: return 20
            case .small: return 16
            }
        }
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

    private var isBig: Bool {
        if isPortrait == true {
            return width == ScreenSize.bigScreenWidth.rawValue
        }

        return height == ScreenSize.bigScreenHeight.rawValue
    }

    private var isMedium: Bool {
        if isPortrait == true {
            return width == ScreenSize.mediumScreenWidth.rawValue
        }

        return height == ScreenSize.mediumScreenHeight.rawValue
    }

    private var isSmall: Bool {
        if isPortrait == true {
            return width == ScreenSize.smallScreenWidth.rawValue
        }

        return height == ScreenSize.smallScreenHeight.rawValue
    }

    private var size: CGSize {
        return view.bounds.size
    }

    private var width: CGFloat {
        return size.width
    }

    private var height: CGFloat {
        return size.height
    }

    private var isPortrait: Bool {
        return height > width
    }
}
