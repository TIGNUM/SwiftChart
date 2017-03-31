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
    struct SideBar {
        static let `default` = UIFont.simpleFont(ofSize: 32)
        static let small = UIFont.simpleFont(ofSize: 16)
    }

    struct Learn {
        static let headertitle = UIFont.simpleFont(ofSize: 36)
        static let headerSubtitle = UIFont.bentonRegularFont(ofSize: 11)
        static let text = UIFont.bentonBookFont(ofSize: 16)
        static let articleHeaderTitle = UIFont.simpleFont(ofSize: 24)
        static let articleTitle = UIFont.simpleFont(ofSize: 20)
        static let whatsHotID = UIFont.simpleFont(ofSize: 18)
        
        struct ContentList {
            struct Cell {
                static let title = UIFont.bentonBookFont(ofSize: 16)
                static let subtitle = UIFont.simpleFont(ofSize: 10)
            }
        }
    }
    
    struct TabBarController {
        static let buttonTitle = UIFont.simpleFont(ofSize: 16)
    }
}

struct Color {
    struct Default {
        static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
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
}

struct AttributedString {
    struct Learn {
        static func headerTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.headerTitle, andFont: Font.Learn.headertitle)
        }

        static func headerSubtitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.headerSubtitle, andFont: Font.Learn.headerSubtitle)
        }

        static func text(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.black, andFont: Font.Learn.text)
        }

        static func videoDescription(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.videoDescription, andFont: Font.Learn.text)
        }

        static func readMoreHeaderTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.black, andFont: Font.Learn.articleHeaderTitle)
        }

        static func readMoreHeaderSubtitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.Learn.headerSubtitle)
        }

        static func articleTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.black, andFont: Font.Learn.articleTitle)
        }

        static func articleSubtitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.Learn.headerSubtitle)
        }

        static func whatsHotID(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.Learn.whatsHotID)
        }

        static func whatsHotTitle(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Learn.articleSubtitle, andFont: Font.Learn.headerSubtitle)
        }

        static func whatsHotText(string: String) -> NSAttributedString {
            return NSAttributedString.create(for: string, withColor: Color.Default.white, andFont: Font.Learn.text)
        }
    }
}
