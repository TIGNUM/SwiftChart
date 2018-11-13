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

struct Animation {
    static let duration_01: TimeInterval = 0.1
    static let duration_02: TimeInterval = 0.2
    static let duration: TimeInterval = 0.3
    static let duration_06: TimeInterval = 0.6
    static let duration_1: TimeInterval = 1
    static let duration_6: TimeInterval = 6
}

enum FontName: String {
    case apercuBold = "Apercu-Bold"
    case apercuMedium = "Apercu-Medium"
    case apercuRegular = "Apercu-Regular"
    case apercuLight = "Apercu-Light"

    func font(of size: CGFloat) -> UIFont {
        return (UIFont(name: rawValue, size: size) ?? UIFont.systemFont(ofSize: size))
    }
}

struct Layout {
    static let articleImageHeight: CGFloat = 200
    static let statusBarHeight: CGFloat = 64
    static let padding_1: CGFloat = 1
    static let padding_5: CGFloat = 5
    static let padding_07: CGFloat = 7
    static let padding_10: CGFloat = 10
    static let padding_12: CGFloat = 12
    static let padding_20: CGFloat = 20
    static let padding_24: CGFloat = 24
    static let padding_16: CGFloat = 16
    static let padding_32: CGFloat = 32
    static let padding_40: CGFloat = 40
    static let padding_50: CGFloat = 50
    static let padding_64: CGFloat = 64
    static let padding_80: CGFloat = 80
    static let padding_90: CGFloat = 90
    static let padding_100: CGFloat = 100
    static let padding_150: CGFloat = 150
    static let height_44: CGFloat = 44
    static let multiplier_01: CGFloat = 0.01
    static let multiplier_06: CGFloat = 0.06
    static let multiplier_015: CGFloat = 0.015
    static let multiplier_08: CGFloat = 0.08
    static let multiplier_03: CGFloat = 0.3
    static let multiplier_010: CGFloat = 0.10
    static let multiplier_020: CGFloat = 0.20
    static let multiplier_025: CGFloat = 0.25
    static let multiplier_030: CGFloat = 0.30
    static let multiplier_035: CGFloat = 0.35
    static let multiplier_050: CGFloat = 0.50
    static let multiplier_053: CGFloat = 0.53
    static let multiplier_065: CGFloat = 0.65
    static let multiplier_075: CGFloat = 0.75
    static let multiplier_080: CGFloat = 0.80
    static let multiplier_150: CGFloat = 1.50
    static let badgeSize = CGSize(width: padding_20, height: padding_20)

    struct TabBarView {
        static let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        static let height: CGFloat = 49
        static let animationDuration: TimeInterval = 0.3
    }

    enum CornerRadius: CGFloat {
        case eight = 8
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

    /// BENTON SANS 11 // subtitles, tags
    static let H7Tag = UIFont.apercuRegular(ofSize: 11)

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
    static let ApercuBold15 = UIFont.apercuBold(ofSize: 14)
}
