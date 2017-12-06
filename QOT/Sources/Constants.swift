//  Constants.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

struct Animation {
    static let duration: TimeInterval = 0.3
}

enum FontName: String {
    case simple = "Simple-Regular"
    case bentonBook = "BentonSans-Book"
    case bentonRegular = "BentonSans"
    case bentonSansCondLight = "BentonSans-CondensedLight"
}

struct Environment {
    #if DEBUG
    static let name = "DEVELOPMENT"
    #else
    static let name = "PRODUCTION"
    #endif
}

struct Layout {

    struct TabBarView {
        static let insets = UIEdgeInsets(top: TabBarView.height, left: 0, bottom: 0, right: 0)
        static let height: CGFloat = 49
        static let animationDuration: TimeInterval = 0.3
    }

    enum CornerRadius: CGFloat {
        case chatLabelInstruction = 8
        case chatLabelOptionNavigation = 5
        case chatLabelOptionUpdate = 10
    }

    struct MeSection {
        let viewControllerFrame: CGRect
        let myWhyPartnerScaleFactor = CGFloat(0.8867924528)

        static let loadOffset: CGFloat = 12
        static let labelHeight: CGFloat = 21
        static let maxPartners: Int = 3
        static let maxWeeklyPage = 5

        var connectionCenter: CGPoint {
            return  CGPoint(x: viewControllerFrame.width, y: viewControllerFrame.height * 0.45)
        }

        var radiusMaxLoad: CGFloat {
            return viewControllerFrame.width * 0.66
        }

        var radiusAverageLoad: CGFloat {
            return viewControllerFrame.width * 0.45
        }

        var profileImageWidth: CGFloat {
            return viewControllerFrame.width * 0.28
        }

        var scrollViewOffset: CGFloat {
            return viewControllerFrame.width * 0.07
        }

        var loadCenterX: CGFloat {
            return (viewControllerFrame.width - (viewControllerFrame.width * 0.08))
        }

        var loadCenterY: CGFloat {
            return viewControllerFrame.height * 0.412
        }

        var loadCenter: CGPoint {
            return CGPoint(x: loadCenterX, y: loadCenterY)
        }

        var universeCenter: CGPoint {
            return CGPoint(x: loadCenterX - profileImageWidth * 0.5, y: loadCenterY - profileImageWidth * 0.5)
        }

        var profileImageViewFrame: CGRect {
            return CGRect(
                x: universeCenter.x,
                y: universeCenter.y,
                width: profileImageWidth,
                height: profileImageWidth
            )
        }

        func myWhyDeviceOffset(_ screenType: MyUniverseViewController.ScreenType) -> CGFloat {
            switch screenType {
            case .big: return 0
            case .medium: return 0
            case .small: return -15
            }
        }

    }
}

enum KeychainConstant: String {
    case username = "com.tignum.qot.username"
    case password = "com.tignum.qot.password"
    case authToken = "com.tignum.qot.token"
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
    static let H7SectorTitle = UIFont.simpleFont(ofSize: 14)

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

struct Color {

    /// White Opacity: 30%
    static let whiteLight = UIColor(white: 1, alpha: 0.3)

    /// White Opacity: 40%
    static let whiteMedium = UIColor(white: 1, alpha: 0.4)

    /// White Opacity: 60%
    static let whiteish = UIColor(white: 1, alpha: 0.6)

    /// cherryRed UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)
    static let cherryRed = UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)

    /// cherryRedTwo UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)
    static let cherryRedTwo = UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)

    /// navigationBarDark UIColor(red: 4/255, green: 11/255, blue: 23/255, alpha: 0.825)
    static let navigationBarDark = UIColor(red: 4/255, green: 11/255, blue: 23/255, alpha: 0.825)

    struct Guide {
        static let cardBackground = UIColor(red: 40/255, green: 52/255, blue: 62/255, alpha: 1)
    }

    struct Default {
        static let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        static let whiteLight = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        static let whiteMedium = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        static let whiteSlightLight = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        static let navy = UIColor(red: 0, green: 45/255, blue: 78/255, alpha: 1)
    }

    struct Learn {
        static let headerTitle = UIColor(red: 4/255, green: 8/255, blue: 20/255, alpha: 1)
        static let headerSubtitle = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        static let videoDescription = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.6)
    }

    struct Sidebar {
        struct Benefits {
            static let headerText = Color.Learn.headerSubtitle
        }
    }

    struct MeSection {
        static let redFilled = UIColor(red: 255/255, green: 0, blue: 38/255, alpha: 1)
        static let redFilledBodyBrain = UIColor(red: 1, green: 0, blue: 34/255, alpha: 0.2)
        static let redStroke = UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 0.9)
        static let whiteStroke = UIColor(white: 1, alpha: 0.6)
        static let whiteLabel = Color.whiteMedium
        static let whiteStrokeLight = UIColor(white: 1, alpha: 0.2)
        static let myUniverseBlue = UIColor(red: 2.0/255.0, green: 38.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        static let backgroundCircle = UIColor(white: 1, alpha: 0.08)
    }
}
