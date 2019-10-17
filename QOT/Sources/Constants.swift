//  Constants.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

struct Defaults {
    static let firstLevelSupportEmail = "support@qot.io"
    static let firstLevelFeatureEmail = "feature@qot.io"
}

struct Toggle {
    static let seperator = "{toggle:seperator}"
}

struct CharacterSpacing {
    static let kern02: CGFloat = 0.2
    static let kern05: CGFloat = 0.5
    static let kern06: CGFloat = 0.6
    static let kern1_2: CGFloat = 1.2
}

struct Animation {
    static let duration_01: TimeInterval = 0.1
    static let duration_02: TimeInterval = 0.2
    static let duration_03: TimeInterval = 0.3
    static let duration_04: TimeInterval = 0.4
    static let duration_06: TimeInterval = 0.6
    static let duration_1_5: TimeInterval = 1.5
    static let duration_3: TimeInterval = 3
}

enum FontName: String {
    case apercuBold = "Apercu-Bold"
    case apercuMedium = "Apercu-Medium"
    case apercuRegular = "Apercu-Regular"
    case apercuLight = "Apercu-Light"

    case sfProTextSemiBold = "SFProText-Semibold"
    case sfProTextMedium = "SFProText-Medium"
    case sfProTextRegular = "SFProText-Regular"
    case sfProTextLight = "SFProText-Light"
    case sfProTextHeavy = "SFProText-Heavy"
    case sfProDisplayLight = "SFProDisplay-Light"
    case sfProDisplayRegular = "SFProDisplay-Regular"
    case sfProDisplayThin = "SFProDisplay-Thin"
    case sfProDisplayUltralight = "SFProDisplay-Ultralight"

    func font(of size: CGFloat) -> UIFont {
        return (UIFont(name: rawValue, size: size) ?? UIFont.systemFont(ofSize: size))
    }
}

extension CGFloat {
    public typealias Radius = CGFloat
    public typealias Button = CGFloat
    public typealias View = CGFloat
    public typealias Width = CGFloat
    public typealias Height = CGFloat
    public typealias Corner = CGFloat
}

extension CGFloat.Button {}

extension CGFloat.Radius {
    static let Three: CGFloat = 3
    static let Nine: CGFloat = 9
    static let Twenty: CGFloat = 20
}

extension CGFloat.View.Height {
    static let Default: CGFloat = 40
    static let ParentNode: CGFloat = 64
    static let ChildNode: CGFloat = 95
    static let Footer: CGFloat = 20
    static let TypingFooter: CGFloat = 80
}

extension CGFloat.Button.Height {
    static let BottomNavBar: CGFloat = 100
    static let AnswerButtonBig: CGFloat = 56
}

extension CGFloat.Button.Width {
    static let DoItLater: CGFloat = 104
    static let TrackTBV: CGFloat = 135
    static let SaveChanges: CGFloat = .TrackTBV
    static let Done: CGFloat = 72
    static let DecisionTree: CGFloat = 168
    static let Cancel: CGFloat = 88
    static let Remove: CGFloat = .Cancel
    static let Keep: CGFloat = .Done
    static let Continue: CGFloat = 100
    static let Save: CGFloat = 80
}

extension CGRect {
    typealias Coach = CGRect
}

extension CGRect.Coach {
    static let Default = CGRect(origin: .zero, size: CGSize(width: .DecisionTree, height: .Default))
}

struct Layout {
    static let cornerRadius08: CGFloat = 8
    static let cornerRadius12: CGFloat = 12
    static let cornerRadius20: CGFloat = 20
    static let padding_24: CGFloat = 24
    static let padding_40: CGFloat = 40
    static let padding_50: CGFloat = 50
    static let padding_100: CGFloat = 100
    static let multiplier_06: CGFloat = 0.06
    static let multiplier_053: CGFloat = 0.53
    static let multiplier_150: CGFloat = 1.50

    struct TabBarView {
        static let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        static let height: CGFloat = 49
        static let animationDuration: TimeInterval = 0.3
    }

    enum CornerRadius: CGFloat {
        case eight = 8
        case nine = 9
        case cornerRadius12 = 12
        case cornerRadius20 = 20
        case chatLabelOptionNavigation = 5
        case chatLabelOptionUpdate = 10
    }
}

extension UIFont {
    /// BENTON SANS 16 // paragraph, body text
    static let PText = UIFont.apercuRegular(ofSize: 16)

    /// BENTON SANS 11 // subtitles, tags
    static let H7Tag = UIFont.apercuRegular(ofSize: 11)

    /// BENTON SANS 13 // paragraph, body text
    static let PTextSmall = UIFont.apercuLight(ofSize: 13)
}
