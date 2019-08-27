//
//  Theme.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 26/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

enum ThemeView: String {
    case level1
    case level2
    case level3
    case level2Selected
    case article
    case articleAudioBar
    case audioBar
    case fade
    case separator

    func apply(_ view: UIView) {
        var color: UIColor?
        switch self {
        case .level1:
            color = Palette.carbon
        case .level2:
            color = Palette.carbon
        case .level3:
            color = Palette.carbon
        case .level2Selected:
            color = Palette.accent10
        case .article:
            color = Palette.light(Palette.sand, or: Palette.carbon)
        case .articleAudioBar:
            color = Palette.light(Palette.carbon, or: Palette.sand)
        case .audioBar:
            view.corner(radius: 20)
            color = Palette.sand
        case .fade:
            color = Palette.light(Palette.sand10, or: Palette.carbon10)
        case .separator:
            color = Palette.light(Palette.carbon10, or: Palette.sand10)
        }

        if let color = color {
            view.backgroundColor = color
        }
    }

    var headerBarHeight: CGFloat {
        return 44.0
    }
}

enum ThemeText: String {
    private static let fontRegular14 = UIFont.sfProtextRegular(ofSize: 14.0)
    private static let fontRegular15 = UIFont.sfProtextRegular(ofSize: 15.0)
    private static let fontRegular16 = UIFont.sfProtextRegular(ofSize: 16.0)
    private static let fontRegular20 = UIFont.sfProtextRegular(ofSize: 20.0)
    private static let fontRegular24 = UIFont.sfProtextRegular(ofSize: 24.0)

    private static let fontMedium12 = UIFont.sfProtextMedium(ofSize: 12.0)
    private static let fontMedium14 = UIFont.sfProtextMedium(ofSize: 14.0)

    private static let fontLight16 = UIFont.sfProtextLight(ofSize: 16.0)
    private static let fontLight20 = UIFont.sfProtextLight(ofSize: 20.0)
    private static let fontLight24 = UIFont.sfProtextLight(ofSize: 24.0)
    private static let fontLight34 = UIFont.sfProtextLight(ofSize: 34.0)
    private static let fontLight40 = UIFont.sfProtextLight(ofSize: 40.0)

    private static let fontSemiBold14 = UIFont.sfProtextSemibold(ofSize: 14.0)

    case navigationBarHeader
    case sectionHeader
    case categoryHeader
    case categorySubHeader
    case whatsHotHeader
    case performanceStaticTitle
    case performanceTitle
    case author
    case datestamp
    case linkMenuItem   //(MyLibrary/Coach)
    case linkMenuComment
    case linkMenuCommentRed
    case searchTopic
    case searchExploreTopic
    case searchBar
    case audioBar
    case articleAudioBar
    case segmentHeading
    case articleCategory
    case articleTitle
    case articleBullet
    case articleBody
    case articleAuthor
    case articleDatestamp
    case articleToolBarTint
    case articleRelatedTitle
    case articleRelatedDetail
    case articleNextTitle
    case strategyHeader
    case strategySubHeader
    case myQOTBoxTitle
    case myQOTTitle

    private var font: UIFont {
        switch self {
        case .navigationBarHeader, .sectionHeader, .categoryHeader:
            return ThemeText.fontRegular20
        case .categorySubHeader, .searchTopic:
            return ThemeText.fontRegular16
        case .performanceStaticTitle, .performanceTitle, .searchExploreTopic, .searchBar, .strategySubHeader:
            return ThemeText.fontRegular14
        case .author, .datestamp, .linkMenuComment, .linkMenuCommentRed:
            return ThemeText.fontMedium12
        case .linkMenuItem, .myQOTBoxTitle:
            return ThemeText.fontLight20
        case .audioBar, .articleAudioBar, .segmentHeading:
            return ThemeText.fontSemiBold14
        case .articleCategory, .articleDatestamp:
            switch textScale {
            case .scale: return ThemeText.fontMedium14
            case .scaleNot: return ThemeText.fontMedium12
            }
        case .articleTitle:
            switch textScale {
            case .scale: return ThemeText.fontLight40
            case .scaleNot: return ThemeText.fontLight34
            }
        case .articleBullet:
            switch textScale {
            case .scale: return ThemeText.fontLight24
            case .scaleNot: return ThemeText.fontLight16
            }
        case .articleBody:
            switch textScale {
            case .scale: return ThemeText.fontRegular24
            case .scaleNot: return ThemeText.fontRegular16
            }
        case .articleRelatedTitle, .myQOTTitle, .whatsHotHeader:
            return ThemeText.fontLight16
        case .articleRelatedDetail:
            return ThemeText.fontMedium12
        case .articleNextTitle:
            return ThemeText.fontMedium14
        case .strategyHeader:
            return ThemeText.fontRegular15
        default:
            return ThemeText.fontRegular20
        }
    }

    private var color: UIColor {
        switch self {
        case .navigationBarHeader,
             .sectionHeader, .categoryHeader, .categorySubHeader, .performanceTitle,
             .strategyHeader, .whatsHotHeader, .myQOTBoxTitle:
            return Palette.sand
        case .author:
            return Palette.sand60
        case .datestamp, .performanceStaticTitle:
            return Palette.sand40
        case .linkMenuItem:
            return Palette.accent
        case .linkMenuComment, .strategySubHeader:
            return Palette.sand70
        case .linkMenuCommentRed:
            return Palette.redOrange
        case .searchTopic:
            return Palette.sand
        case .searchExploreTopic:
            return Palette.sand40
        case .searchBar:
            return Palette.sand40
        case .audioBar:
            return Palette.accent
        case .articleAudioBar:
            return Palette.light(Palette.sand60, or: Palette.carbon60)
        case .segmentHeading:
            return Palette.sand
        case .articleBullet:
            return Palette.sand70
        case .articleCategory, .articleRelatedDetail:
            return Palette.light(Palette.carbon30, or: Palette.sand30)
        case .articleTitle, .articleRelatedTitle, .articleBody, .myQOTTitle:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .articleAuthor:
            return Palette.light(Palette.carbon60, or: Palette.sand60)
        case .articleDatestamp:
            return Palette.light(Palette.carbon30, or: Palette.sand30)
        case .articleNextTitle:
            return Palette.light(Palette.carbon40, or: Palette.sand40)
        case .articleToolBarTint:
            return Palette.accent
        }
    }

    func apply(_ text: String, to view: UILabel) {
        var string: NSAttributedString?
        var bkgdColor: UIColor = .clear

        switch self {
        case .navigationBarHeader, .articleCategory, .articleAuthor, .articleDatestamp, .author:
            string = NSAttributedString(string: text, letterSpacing: 0.4, font: self.font, textColor: self.color, alignment: .left)
        case .myQOTBoxTitle:
            string = NSAttributedString(string: text.uppercased(), letterSpacing: 0.4, font: self.font, textColor: self.color, alignment: .left)
        case .performanceStaticTitle:
            string = NSAttributedString(string: text.uppercased(), letterSpacing: 0.3, font: self.font, textColor: self.color, alignment: .left)
        case .linkMenuItem:
            string = NSAttributedString(string: text.uppercased(), letterSpacing: 0.0, font: self.font, lineSpacing: 0, textColor: self.color, alignment: .left)
        case .linkMenuComment, .linkMenuCommentRed:
            string = NSAttributedString(string: text, letterSpacing: 0.0, font: self.font, lineSpacing: 0, textColor: self.color, alignment: .left)
        case .articleTitle:
            string = NSAttributedString(string: text.uppercased(), letterSpacing: 0.2, font: self.font, lineSpacing: 4, textColor: self.color, alignment: .left)
        case .strategyHeader:
            string = NSAttributedString(string: text.uppercased(), letterSpacing: 0.3, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .strategySubHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .articleRelatedTitle, .articleNextTitle, .myQOTTitle, .whatsHotHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, lineSpacing: 1, textColor: self.color, alignment: .left)
        case .articleBullet, .sectionHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .articleRelatedDetail:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, textColor: self.color, alignment: .left)
        case .articleAudioBar, .audioBar:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .left)
        case .datestamp:
            string = NSAttributedString(string: text, letterSpacing: 0.0, font: self.font, lineSpacing: 0, textColor: self.color, alignment: .left)
        default:
            bkgdColor = .red
        }

        if let string = string {
            view.attributedText = string
        }
        view.backgroundColor = bkgdColor
    }
}

private struct Palette {
    static var accent: UIColor {
        return UIColor(red: 182/255, green: 155/255, blue: 134/255, alpha: 1)
    }

    static var accent10: UIColor {
        return UIColor.accent.withAlphaComponent(0.1)
    }

    static var carbonDark: UIColor {
        return UIColor(red: 8/255, green: 8/255, blue: 7/255, alpha: 1)
    }

    static var sand: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 1)
    }

    static var sand10: UIColor {
        return UIColor.sand.withAlphaComponent(0.1)
    }

    static var sand30: UIColor {
        return UIColor.sand.withAlphaComponent(0.3)
    }

    static var sand40: UIColor {
        return UIColor.sand.withAlphaComponent(0.4)
    }

    static var sand60: UIColor {
        return UIColor.sand.withAlphaComponent(0.6)
    }

    static var sand70: UIColor {
        return UIColor.sand.withAlphaComponent(0.7)
    }

    static var carbon: UIColor {
        return UIColor(red: 20/255, green: 19/255, blue: 18/255, alpha: 1)
    }

    static var carbon10: UIColor {
        return UIColor.carbon.withAlphaComponent(0.1)
    }

    static var carbon30: UIColor {
        return UIColor.carbon.withAlphaComponent(0.3)
    }

    static var carbon40: UIColor {
        return UIColor.carbon.withAlphaComponent(0.4)
    }

    static var carbon60: UIColor {
        return UIColor.carbon.withAlphaComponent(0.6)
    }

    static var redOrange: UIColor {
        return UIColor(red: 238/255, green: 94/255, blue: 85/255, alpha: 1)
    }

    static func light(_ lightColor: UIColor, or darkColor: UIColor) -> UIColor {
        switch colorMode {
        case .dark: return darkColor
        case .darkNot: return lightColor
        }
    }
}
