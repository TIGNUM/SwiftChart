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

    enum CornerRadius: CGFloat {
        case chatLabelInstruction = 8
        case chatLabelOptionNavigation = 5
        case chatLabelOptionUpdate = 10
    }

    struct MeSection {
        let viewControllerFrame: CGRect

        static let loadOffset: CGFloat = 12
        static let labelHeight: CGFloat = 21

        var connectionCenter: CGPoint {
            return  CGPoint(x: viewControllerFrame.width, y: viewControllerFrame.height * 0.5)
        }

        var radiusMaxLoad: CGFloat {
            return viewControllerFrame.width * 0.7
        }

        var radiusAverageLoad: CGFloat {
            return viewControllerFrame.width * 0.45
        }

        var profileImageWidth: CGFloat {
            return viewControllerFrame.width * 0.25
        }

        var scrollViewOffset: CGFloat {
            return viewControllerFrame.width * 0.06
        }

        var loadCenterX: CGFloat {
            return (viewControllerFrame.width - (viewControllerFrame.width * 0.06))
        }

        var loadCenterY: CGFloat {
            return viewControllerFrame.height * 0.5
        }

        var loadCenter: CGPoint {
            return CGPoint(x: loadCenterX, y: loadCenterY)
        }

        var profileImageViewFrame: CGRect {
            return CGRect(
                x: loadCenterX - profileImageWidth * 0.5,
                y: loadCenterY - profileImageWidth * 0.5,
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
    static let H5SecondaryHeadline = UIFont.simpleFont(ofSize: 16)

    /// SIMPLE REGULAR 14 // navigation title
    static let H6NavigationTitle = UIFont.simpleFont(ofSize: 14)

    /// BENTON SANS 11 // subtitles, tags
    static let H7Tag = UIFont.bentonRegularFont(ofSize: 11)

    /// BENTON SANS 16 // paragraph, body text
    static let PText = UIFont.bentonRegularFont(ofSize: 16)
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
                return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.H5SecondaryHeadline)
            }

            static func title(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.H7Tag)
            }

            static func text(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H5SecondaryHeadline)
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
                return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.H1MainTitle)
            }

            static func newTemplateMediaDescription(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.H5SecondaryHeadline)
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
        struct Benefits {
            static func headerTitle(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H1MainTitle)
            }

            static func headerText(string: String) -> NSAttributedString {
                return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.H1MainTitle)
            }
        }
    }

    struct MeSection {
        static func sectorTitle(text: String) -> NSAttributedString {
            return NSAttributedString.create(for: text, withColor: Color.whiteMedium, andFont: Font.H7Tag, letterSpacing: 2)
        }

        static func sectorTitleCritical(text: String) -> NSAttributedString {
            return NSAttributedString.create(for: text, withColor: Color.cherryRedTwo, andFont: Font.PText, letterSpacing: 2.7)
        }
    }
}
