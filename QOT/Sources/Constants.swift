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

struct Animation {
    static let duration: TimeInterval = 0.3
    static let duration_06: TimeInterval = 0.6
}

enum FontName: String {
    case simple = "Simple-Regular"
    case bentonBook = "BentonSans-Book"
    case bentonRegular = "BentonSans"
    case bentonSansCondLight = "BentonSans-CondensedLight"
    case apercuBold = "Apercu-Bold"
    case apercuMedium = "Apercu-Medium"
    case apercuRegular = "Apercu-Regular"
    case apercuLight = "Apercu-Light"
}

struct Layout {

    static let statusBarHeight: CGFloat = 64
    static let paddingTop: CGFloat = 24

    struct TabBarView {
        static let insets = UIEdgeInsets(top: TabBarView.height, left: 0, bottom: 0, right: 0)
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
}

enum KeychainConstant: String {
    case username = "com.tignum.qot.username"
    case password = "com.tignum.qot.password"
    case deviceID = "com.tignum.qot.device-identifier"
    case databaseKey = "com.tignum.qot.database.key"
}

struct Font {

    enum Name: String {
        case h2SecondaryTitle
        case h5SecondaryHeadline

        static func font(name: String) -> UIFont {
            switch name {
            case Name.h2SecondaryTitle.rawValue: return Font.H2SecondaryTitle
            case Name.h5SecondaryHeadline.rawValue: return Font.H5SecondaryHeadline
            default: return Font.H4Headline
            }
        }
    }

    /// SIMPLE REGUAR 72 // Number title
    static let H0Number = UIFont.simpleFont(ofSize: 72)

    /// SIMPLE REGULAR 36 // main post title
    static let H1MainTitle = UIFont.simpleFont(ofSize: 36)

    /// SIMPLE REGULAR 32 // video title, main diagram title, sidemenu
    static let H2SecondaryTitle = UIFont.simpleFont(ofSize: 32)

    /// SIMPLE REGULAR 24 // bubble title, ME numbers, ME secondary cards title
    static let H3Subtitle = UIFont.simpleFont(ofSize: 24)

    /// SIMPLE REGULAR 20 // recommended article title
    static let H4Headline = UIFont.simpleFont(ofSize: 20)

    /// SIMPLE REGULAR 18 // strategy title
    static let H4Identifier = UIFont.simpleFont(ofSize: 18)

    /// SIMPLE REGULAR 16 // strategy title
    static let H5SecondaryHeadline = UIFont.simpleFont(ofSize: 16)

    /// SIMPLE REGULAR 14 // navigation title
    static let H6NavigationTitle = UIFont.simpleFont(ofSize: 14)

    /// SIMPLE REGULAR 11 // MyUniverse sector title
    static let H7SectorTitle = UIFont.simpleFont(ofSize: 11)

    /// BENTON SANS 11 // subtitles, tags
    static let H7Tag = UIFont.bentonRegularFont(ofSize: 11)

    /// BENTON SANS 16 // paragraph, body text
    static let PText = UIFont.bentonRegularFont(ofSize: 16)

    /// BENTON SAN BOOK 11 // title
    static let H7Title = UIFont.bentonBookFont(ofSize: 11)

    /// BENTON SAN BOOK 12 // text
    static let H8Title = UIFont.bentonBookFont(ofSize: 12)

    /// BENTON SAN BOOK 19 // title
    static let H9Title = UIFont.bentonBookFont(ofSize: 19)

    /// BENTON SAN BOOK 18 // subtitile
    static let H8Subtitle = UIFont.bentonBookFont(ofSize: 18)

    /// BENTON SANS 13 // paragraph, body text
    static let PTextSmall = UIFont.bentonRegularFont(ofSize: 13)

    /// BENTON SANS 11 // paragraph, body text
    static let PTextSubtitle = UIFont.bentonRegularFont(ofSize: 11)

    /// BENTON SANS BOOK 16 // body text
    static let DPText = UIFont.bentonBookFont(ofSize: 16)

    /// BENTON SAN BOOK 15 // text
    static let DPText2 = UIFont.bentonBookFont(ofSize: 15)

    /// BENTON SAN BOOK 14 // text
    static let DPText3 = UIFont.bentonBookFont(ofSize: 14)

    /// BENTON SANS Condensed Light // QOUTES
    static let Qoute = UIFont.bentonCondLightFont(ofSize: 28)
}
