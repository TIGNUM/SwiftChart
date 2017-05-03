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
        static let animationDuration: TimeInterval = 0.3
        static let selectedButtonColor: UIColor = .white
        static let deselectedButtonColor: UIColor = UIColor.white.withAlphaComponent(0.4)
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

struct Font {

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

    /// White Opacity: 50%
    static let whiteMedium = UIColor(white: 1, alpha: 0.5)

    /// cherryRed UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)
    static let cherryRed = UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)

    /// cherryRedTwo UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)
    static let cherryRedTwo = UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)

    struct Default {
        static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let blackMedium = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
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
        static let articleSubtitle = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
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

struct AttributedString {
    struct Learn {
        static func headerTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.headerTitle, andFont: Font.H1MainTitle)
        }

        static func headerSubtitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.headerSubtitle, andFont: Font.H7Tag)
        }

        static func text(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.black, andFont: Font.H5SecondaryHeadline)
        }

        static func mediaDescription(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.blackMedium, andFont: Font.H5SecondaryHeadline)
        }

        static func readMoreHeaderTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.black, andFont: Font.H3Subtitle)
        }

        static func readMoreHeaderSubtitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.H7Tag)
        }

        static func articleTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.black, andFont: Font.H4Headline)
        }

        static func articleSubtitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.H7Tag)
        }

        struct WhatsHot {
            static func identifier(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H4Identifier )
            }

            static func title(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.MeSection.whiteStroke, andFont: Font.H7Title)
            }

            static func text(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H4Headline)
            }

            static func newTemplateHeaderTitle(string: String) -> NSAttributedString {
                return AttributedString.Learn.readMoreHeaderSubtitle(string: string)
            }

            static func newTemplateHeaderSubitle(string: String) -> NSAttributedString {
                return AttributedString.Learn.headerSubtitle(string: string)
            }

            static func newTemplateTitle(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H1MainTitle)
            }

            static func newTemplateSubtitle(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.MeSection.whiteStroke, andFont: Font.H1MainTitle)
            }

            static func newTemplateMediaDescription(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.MeSection.whiteStroke, andFont: Font.H7Title)
            }

            static func newTemplateLoadMoreTitle(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H3Subtitle)
            }

            static func newTemplateLoadMoreSubtitle(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.H7Tag)
            }
        }
    }

    struct Sidebar {

        struct SideBarItems {

            struct Benefits {
                static func headerTitle(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H1MainTitle)
                }

                static func headerText(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.whiteMedium, andFont: Font.H7Tag)
                }

                static func text(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H7Tag)
                }
            }

            struct DataPrivacy {
                static func headerTitle(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H3Subtitle)
                }

                static func headerText(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.DPText)
                }

                static func text(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.whiteMedium, andFont: Font.H7Tag)
                }

            }

            struct AboutTignum {
                static func headerTitle(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H1MainTitle)
                }

                static func headerSubTitle(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H2SecondaryTitle)
                }

                static func text(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.DPText)
                }

                static func shareText(string: String) -> NSAttributedString {
                    return NSAttributedString.create(for: string, withColor: Color.Default.whiteMedium, andFont: Font.DPText)
                }
            }
        }
    }

    struct Library {
        static func categoryTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H3Subtitle)
        }

        static func categoryHeadline(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.whiteSlightLight, andFont: Font.H7Tag)
        }

        static func categoryMediaTypeLabel(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.whiteMedium, andFont: Font.H7Tag)
        }

        static func latestPostTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.whiteSlightLight, andFont: Font.H7Tag)
        }

    }

    struct MeSection {
        static func sectorTitle(text: String, screenType: MyUniverseViewController.ScreenType) -> NSAttributedString {
            switch screenType {
            case .big: return NSAttributedString.create(for: text, withColor: Color.whiteMedium, andFont: Font.H7Tag, letterSpacing: 2)
            case .medium: return NSAttributedString.create(for: text, withColor: Color.whiteMedium, andFont: Font.H7Tag, letterSpacing: 1.8)
            case .small: return NSAttributedString.create(for: text, withColor: Color.whiteMedium, andFont: Font.H7Tag, letterSpacing: 1.6)
            }
        }

        static func sectorTitleCritical(text: String, screenType: MyUniverseViewController.ScreenType) -> NSAttributedString {
            switch screenType {
            case .big: return NSAttributedString.create(for: text, withColor: Color.cherryRedTwo, andFont: Font.PText, letterSpacing: 2.7)
            case .medium: return NSAttributedString.create(for: text, withColor: Color.cherryRedTwo, andFont: Font.PTextSmall, letterSpacing: 2.5)
            case .small: return NSAttributedString.create(for: text, withColor: Color.cherryRedTwo, andFont: Font.PTextSmall, letterSpacing: 2.3)
            }
        }
    }
}
