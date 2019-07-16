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
    static let totalNumberOfStrategies = 55
}

struct Toggle {
    static let seperator = "{toggle:seperator}"
}

struct FontSize {
    static let fontSize16: CGFloat = 16
    static let fontSize14: CGFloat = 14
    static let fontSize12: CGFloat = 12
}

struct Animation {
    static let duration_00: TimeInterval = 00
    static let duration_01: TimeInterval = 0.1
    static let duration_02: TimeInterval = 0.2
    static let duration_03: TimeInterval = 0.3
    static let duration_04: TimeInterval = 0.4
    static let duration_06: TimeInterval = 0.6
    static let duration_075: TimeInterval = 0.75
    static let duration_1: TimeInterval = 1
    static let duration_1_5: TimeInterval = 1.5
    static let duration_3: TimeInterval = 3
    static let duration_6: TimeInterval = 6
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
    case sfProDisplayLight = "SFProDisplay-Light"
    case sfProDisplayRegular = "SFProDisplay-Regular"
    case sfProDisplayThin = "SFProDisplay-Thin"
    case sfProDisplayUltralight = "SFProDisplay-Ultralight"

    func font(of size: CGFloat) -> UIFont {
        return (UIFont(name: rawValue, size: size) ?? UIFont.systemFont(ofSize: size))
    }
}

extension CGFloat {
    static let bottomNavBarHeight: CGFloat = 100
    static let buttonHeight: CGFloat = 40
    static let doneButtonWidth: CGFloat = 72
    static let saveAndContinueButtonWidth: CGFloat = 152
    static let decisionTreeButtonWidth: CGFloat = 168
}

struct Layout {
    static let cornerRadius12: CGFloat = 12
    static let cornerRadius20: CGFloat = 20
    static let articleImageHeight: CGFloat = 200
    static let statusBarHeight: CGFloat = 64
    static let padding_1: CGFloat = 1
    static let padding_4: CGFloat = 4
    static let padding_5: CGFloat = 5
    static let padding_07: CGFloat = 7
    static let padding_10: CGFloat = 10
    static let padding_12: CGFloat = 12
    static let padding_20: CGFloat = 20
    static let padding_24: CGFloat = 24
    static let padding_16: CGFloat = 16
    static let padding_32: CGFloat = 32
    static let padding_35: CGFloat = 35
    static let padding_40: CGFloat = 40
    static let padding_50: CGFloat = 50
    static let padding_58: CGFloat = 58
    static let padding_64: CGFloat = 64
    static let padding_80: CGFloat = 80
    static let padding_90: CGFloat = 90
    static let padding_100: CGFloat = 100
    static let padding_150: CGFloat = 150
    static let height_44: CGFloat = 44
    static let multiplier_01: CGFloat = 0.01
    static let multiplier_002: CGFloat = 0.02
    static let multiplier_003: CGFloat = 0.03
    static let multiplier_004: CGFloat = 0.04
    static let multiplier_06: CGFloat = 0.06
    static let multiplier_09: CGFloat = 0.09
    static let multiplier_0015: CGFloat = 0.015
    static let multiplier_08: CGFloat = 0.08
    static let multiplier_03: CGFloat = 0.3
    static let multiplier_05: CGFloat = 0.5
    static let multiplier_010: CGFloat = 0.10
    static let multiplier_015: CGFloat = 0.15
    static let multiplier_018: CGFloat = 0.18
    static let multiplier_020: CGFloat = 0.20
    static let multiplier_025: CGFloat = 0.25
    static let multiplier_030: CGFloat = 0.30
    static let multiplier_035: CGFloat = 0.35
    static let multiplier_050: CGFloat = 0.50
    static let multiplier_053: CGFloat = 0.53
    static let multiplier_065: CGFloat = 0.65
    static let multiplier_075: CGFloat = 0.75
    static let multiplier_080: CGFloat = 0.80
    static let multiplier_105: CGFloat = 1.05
    static let multiplier_110: CGFloat = 1.10
    static let multiplier_120: CGFloat = 1.20
    static let multiplier_125: CGFloat = 1.25
    static let multiplier_150: CGFloat = 1.50
    static let multiplier_175: CGFloat = 1.75
    static let badgeSize = CGSize(width: padding_20, height: padding_20)

    struct TabBarView {
        static let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        static let height: CGFloat = 49
        static let animationDuration: TimeInterval = 0.3
    }

    enum CornerRadius: CGFloat {
        case eight = 8
        case cornerRadius12 = 12
        case cornerRadius20 = 20
        case chatLabelOptionNavigation = 5
        case chatLabelOptionUpdate = 10
    }

    struct MeSection {
        static let maxWeeklyPage = 5
        static let maxPartners = 3
    }

    struct Device {
        static let iPhone5width: CGFloat = 374
    }

    struct Transparency {
        static let alpha_01: CGFloat = 0.1
        static let alpha_02: CGFloat = 0.2
        static let alpha_03: CGFloat = 0.3
        static let alpha_04: CGFloat = 0.4
        static let alpha_05: CGFloat = 0.5
        static let alpha_06: CGFloat = 0.6
        static let alpha_07: CGFloat = 0.7
        static let alpha_08: CGFloat = 0.8
        static let alpha_09: CGFloat = 0.9
        static let alpha_1: CGFloat = 1.0
    }
}

enum KeychainConstant: String {
    case username = "com.tignum.qot.username"
    case password = "com.tignum.qot.password"
    case deviceID = "com.tignum.qot.device-identifier"
    case databaseKey = "com.tignum.qot.database.key"
}

extension UIFont {

    /// SIMPLE REGUAR 72 // Number title
    static let H0Number = UIFont.apercuRegular(ofSize: 72)

    /// SIMPLE REGULAR 36 // main post title
    static let H1MainTitle = UIFont.apercuRegular(ofSize: 36)

    static let H1TitleLight = UIFont.apercuLight(ofSize: 25)

    static let H1TitleBold = UIFont.apercuBold(ofSize: 25)

    static let H1TitleRegular = UIFont.apercuRegular(ofSize: 25)

    static let H2SubtitleLight = UIFont.apercuLight(ofSize: 24)

    /// SIMPLE REGULAR 32 // video title, main diagram title, sidemenu
    static let H2SecondaryTitle = UIFont.apercuRegular(ofSize: 32)

    /// SIMPLE REGULAR 24 // ME numbers, ME secondary cards title
    static let H3Subtitle = UIFont.apercuRegular(ofSize: 24)

    /// SIMPLE REGULAR 20 // recommended article title
    static let H4Headline = UIFont.apercuRegular(ofSize: 20)

    /// SIMPLE REGULAR 18 // bubble title, strategy title
    static let H4Identifier = UIFont.apercuRegular(ofSize: 18)

    /// SIMPLE REGULAR 16 // strategy title
    static let H5SecondaryHeadline = UIFont.apercuRegular(ofSize: 16)

    /// SIMPLE REGULAR 14 // navigation title
    static let H6NavigationTitle = UIFont.apercuRegular(ofSize: 14)

    /// SIMPLE REGULAR 11 // MyUniverse sector title
    static let H7SectorTitle = UIFont.apercuRegular(ofSize: 11)

    static let H10Tag = UIFont.apercuRegular(ofSize: 10)

    /// BENTON SANS 11 // subtitles, tags
    static let H7Tag = UIFont.apercuRegular(ofSize: 11)

    /// BENTON SANS 11 // subtitles, tags
    static let H12Tag = UIFont.apercuRegular(ofSize: 12)

    // APERCU REGULAR 13
    static let ApercuRegular11 = UIFont.apercuRegular(ofSize: 11)

    // APERCU REGULAR 13
    static let ApercuRegular13 = UIFont.apercuRegular(ofSize: 13)

    // APERCU REGULAR 15 // Guide action labels
    static let ApercuRegular15 = UIFont.apercuRegular(ofSize: 15)

    /// BENTON SANS 16 // paragraph, body text
    static let PText = UIFont.apercuRegular(ofSize: 16)

    /// BENTON SAN BOOK 11 // title
    static let H7Title = UIFont.apercuMedium(ofSize: 11)

    /// BENTON SANS 8 // subtitles, tags
    static let H8Tag = UIFont.apercuRegular(ofSize: 8)

    /// BENTON SAN BOOK 12 // text
    static let H8Title = UIFont.apercuMedium(ofSize: 12)

    /// BENTON SAN BOOK 19 // title
    static let H9Title = UIFont.apercuLight(ofSize: 19)

    /// BENTON SAN BOOK 18 // subtitile
    static let H8Subtitle = UIFont.apercuLight(ofSize: 18)

    /// BENTON SANS 13 // paragraph, body text
    static let PTextSmall = UIFont.apercuLight(ofSize: 13)

    /// BENTON SANS 11 // paragraph, body text
    static let PTextSubtitle = UIFont.apercuLight(ofSize: 11)

    /// BENTON SANS BOOK 16 // body text
    static let DPText = UIFont.apercuLight(ofSize: 16)

    /// BENTON SAN BOOK 15 // text
    static let DPText2 = UIFont.apercuLight(ofSize: 15)

    /// BENTON SAN BOOK 14 // text
    static let DPText3 = UIFont.apercuLight(ofSize: 14)

    /// BENTON SANS Condensed Light // QOUTES
    static let Qoute = UIFont.apercuLight(ofSize: 28)

    /// apercu Medium 10
    static let TabBar = UIFont.apercuMedium(ofSize: 10)

    // Apercu Medium 31 // Daily Prep minute card title
    static let ApercuMedium31 = UIFont.apercuMedium(ofSize: 31)

    // Apercu Bold 14 // Guide cards action label
    static let ApercuBold14 = UIFont.apercuBold(ofSize: 14)

    // Apercu Bold 15 // Guide type action label
    static let ApercuBold15 = UIFont.apercuBold(ofSize: 15)

    // Apercu Bold 16 // Feature explainers action button
    static let ApercuBold16 = UIFont.apercuBold(ofSize: 16)

    // Apercu Bold 18 // Guide Card Title
    static let ApercuBold18 = UIFont.apercuBold(ofSize: 18)
}
