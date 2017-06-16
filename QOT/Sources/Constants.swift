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

    struct TabBarView {
        static let insets = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        static let height: CGFloat = 64
        static let animationDuration: TimeInterval = 0.3
        static let selectedButtonColor: UIColor = .white
        static let deselectedButtonColor: UIColor = UIColor.white.withAlphaComponent(0.4)
        static let selectedButtonColorLightTheme: UIColor = .black
        static let deselectedButtonColorLightTheme: UIColor = UIColor.black.withAlphaComponent(0.3)
        static let stackViewHorizontalPaddingBottom: CGFloat = 16
        static let indicatorViewExtendedWidthBottom: CGFloat = 16
        static let stackViewHorizontalPaddingTop: CGFloat = 6
        static let indicatorViewExtendedWidthTop: CGFloat = 6
    }

    enum CellHeight: CGFloat {
        case sidebar = 75
        case sidebarSmall = 65
        case sidebarHeader = 50
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

        var connectionCenter: CGPoint {
            return  CGPoint(x: viewControllerFrame.width, y: viewControllerFrame.height * 0.5)
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

        var myWhyVisionFooterXPos: CGFloat {
            return viewControllerFrame.width * 0.115
        }

        var myWhyVisionFooterYPos: CGFloat {
            return viewControllerFrame.height * 0.325
        }

        func myWhyVisionFooterFrame(_ screenType: MyUniverseViewController.ScreenType) -> CGRect {
            var deviceOffset: CGFloat = 0

            switch screenType {
            case .big: deviceOffset = 0
            case .medium: deviceOffset = 0
            case .small: deviceOffset = -15
            }

            return CGRect(
                x: myWhyVisionFooterXPos,
                y: myWhyVisionFooterYPos + deviceOffset,
                width: 0,
                height: Layout.MeSection.labelHeight
            )
        }

        func myWhyVisionLabelFrame(_ screenType: MyUniverseViewController.ScreenType) -> CGRect {
            var deviceOffset: CGFloat = 0

            switch screenType {
            case .big: deviceOffset = 0
            case .medium: deviceOffset = 15
            case .small: deviceOffset = -15
            }

            return CGRect(
                x: myWhyVisionFooterXPos,
                y: (viewControllerFrame.height * 0.15) + deviceOffset,
                width: profileImageWidth * 2.25,
                height: Layout.MeSection.labelHeight
            )
        }

        var myWhyWeeklyChoicesFooterXPos: CGFloat {
            return viewControllerFrame.width * 0.25
        }

        var myWhyWeeklyChoicesFooterYPos: CGFloat {
            return viewControllerFrame.height * 0.57
        }

        var myWhyWeeklyChoicesFooterFrame: CGRect {
            return CGRect(
                x: myWhyWeeklyChoicesFooterXPos,
                y: myWhyWeeklyChoicesFooterYPos + 10,
                width: 0,
                height: Layout.MeSection.labelHeight
            )
        }

        var myWhyPartnersFooterXPos: CGFloat {
            return viewControllerFrame.width * 0.08
        }

        var myWhyPartnersFooterYPos: CGFloat {
            return viewControllerFrame.height * 0.7
        }

        var myWhyPartnersFooterFrame: CGRect {
            return CGRect(
                x: myWhyPartnersFooterXPos,
                y: myWhyPartnersFooterYPos + 10,
                width: 0,
                height: Layout.MeSection.labelHeight
            )
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
    }
}

struct Databsase {
    enum Key: String {
        case primary = "id"
        case sort = "sort"
    }
}

enum Identifier: String {
    case chatTableViewCell = "Cell"
}

enum KeychainConstant: String {
    case service = "com.tignum.qot"
    case username = "com.tignum.qot.username"
    case password = "com.tignum.qot.password"
    case authToken = "com.tignum.qot.token"
    case deviceID = "com.tignum.qot.device-identifier"
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

    /// SIMPLE REGULAR 36 // main post title
    static let H1MainTitle = UIFont.simpleFont(ofSize: 36)

    /// SIMPLE REGULAR 32 // video title, main diagram title, sidemenu
    static let H2SecondaryTitle = UIFont.simpleFont(ofSize: 32)

    /// SIMPLE REGULAR 24 // bubble title, ME numbers, ME secondary cards title
    static let H3Subtitle = UIFont.simpleFont(ofSize: 24)

    /// SIMPLE REGULAR 20 // recommended article title
    static let H4Headline = UIFont.simpleFont(ofSize: 20)

    /// SIMPLE REGULAR 16 // strategy title
    static let H4Identifier = UIFont.simpleFont(ofSize: 18)

    /// SIMPLE REGULAR 16 // strategy title
    static let H5SecondaryHeadline = UIFont.simpleFont(ofSize: 16)

    /// SIMPLE REGULAR 14 // navigation title
    static let H6NavigationTitle = UIFont.simpleFont(ofSize: 14)

    /// BENTON SANS 11 // subtitles, tags
    static let H7Tag = UIFont.bentonRegularFont(ofSize: 11)

    /// BENTON SANS 16 // paragraph, body text
    static let PText = UIFont.bentonRegularFont(ofSize: 16)

    /// BENTON SAN BOOK 11 // title
    static let H7Title = UIFont.bentonBookFont(ofSize: 11)

    /// BENTON SANS 13 // paragraph, body text
    static let PTextSmall = UIFont.bentonRegularFont(ofSize: 13)

    /// BENTON SAN BOOK 16 // body text
    static let DPText = UIFont.bentonBookFont(ofSize: 16)
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
    }
}
