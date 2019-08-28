//
//  Theme.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 26/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct ThemeAppearance {
    static func setNavigationBar() {
        UINavigationBar.appearance().titleTextAttributes = [.font: Fonts.fontMedium20,
                                                            .foregroundColor: Palette.light(Palette.carbon, or: Palette.sand)]
    }

    static func setNavigation(bar: UINavigationBar?, theme: ThemeView) {
        bar?.barTintColor = theme.color
    }
}

enum TextScale {
    case scale
    case scaleNot
}

enum ThemeColorMode {
    case dark
    case light
}

enum ThemeView {
    case level1
    case level2
    case level3
    case level1Secondary
    case level1Selected
    case level2Selected
    case article
    case articleBackground(ThemeColorMode?)
    case articleSeparator(ThemeColorMode?)
    case articleAudioBar
    case audioBar
    case fade
    case separator
    case accentBackground

    var color: UIColor {
        switch self {
        case .level1:
            return Palette.carbonDark
        case .level2:
            return Palette.carbon
        case .level3:
            return Palette.carbon

        case .level1Secondary:
            return Palette.carbon
        case .level1Selected:
            return Palette.accent04
        case .level2Selected:
            return Palette.accent10

        case .article:
            return Palette.light(Palette.sand, or: Palette.carbon)
        case .articleBackground(let mode):
            return Palette.light(Palette.sand, or: Palette.carbon, forcedColorMode: mode)
        case .articleSeparator(let mode):
            return Palette.light(Palette.carbon10, or: Palette.sand10, forcedColorMode: mode)
        case .articleAudioBar:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .audioBar:
            return Palette.sand
        case .fade:
            return Palette.light(Palette.sand10, or: Palette.carbon10)
        case .separator:
            return Palette.light(Palette.carbon10, or: Palette.sand10)
        case .accentBackground:
            return Palette.accent30
        }
    }

    func apply(_ view: UIView) {
        switch self {
        case .audioBar:
            view.corner(radius: 20)
        case .accentBackground:
            view.corner(radius: view.frame.size.height / 2)
        default:
            break
        }

        view.backgroundColor = color
    }

    var headerBarHeight: CGFloat {
        return 44.0
    }
}

enum ThemeBorder {
    case accent
    case accentBackground

    func apply(_ view: UIView) {
        var color: UIColor?
        switch self {
        case .accent:
            color = Palette.accent
        case .accentBackground:
            color = Palette.accent30
        }

        if let color = color {
            view.layer.borderWidth = 1
            view.layer.borderColor = color.cgColor
            view.corner(radius: 20)
        }
    }
}

enum ThemeTint {
    case accent

    func apply(_ view: UIView) {
        var color: UIColor?
        switch self {
        case .accent:
            color = Palette.accent
        }
        if let color = color {
            view.tintColor = color
        }
    }
}

enum ThemeText {
    case navigationBarHeader
    case sectionHeader
    case categoryHeader
    case categorySubHeader
    case whatsHotHeader(ThemeColorMode?)
    case performanceStaticTitle
    case performanceTitle
    case author
    case datestamp

    case linkMenuItem
    case linkMenuComment
    case linkMenuCommentRed

    case searchTopic
    case searchExploreTopic
    case searchBar

    case audioBar
    case articleAudioBar

    case segmentHeading

    case articleCategory
    case articleCategoryNotScaled
    case articleTitle
    case articleTitleNotScaled
    case articleBullet
    case articleBody
    case articleAuthor(ThemeColorMode?)
    case articleDatestamp(ThemeColorMode?)
    case articleToolBarTint
    case articleRelatedTitle
    case articleRelatedDetail
    case articleNextTitle

    case articlePostTitle
    case articlePostTitleNight
    case articleSecondaryTitle
    case articleSubTitle
    case articleHeadline
    case articleHeadlineSmall
    case articleHeadlineSmallRed
    case articleHeadlineSmallFade
    case articleHeadlineSmallLight
    case articleNavigationTitle

    case version

    case articleTag
    case articleTagSelected
    case articleTagNight
    case articleTagTitle
    case articleParagraph
    case articleQuote
    case article
    case articleMediaDescription
    case articleQuestion
    case articleSub
    case articleNum
    case articleSector
    case articleMarkRead

    case placeholder

    case guideNavigationTitle
    case calendarNoAccess

    case learnVideo
    case learnImage
    case learnPDF

    case chatButton
    case chatButtonEnabled

    case settingsTitle
    case settingsTitleFade

    case strategyHeader
    case strategySubHeader
    case myQOTBoxTitle
    case myQOTTitle

    private var font: UIFont {
        switch self {
        case .navigationBarHeader, .sectionHeader, .categoryHeader:
            return Fonts.fontRegular20
        case .categorySubHeader, .searchTopic:
            return Fonts.fontRegular16
        case .performanceStaticTitle, .performanceTitle, .searchExploreTopic, .searchBar, .strategySubHeader:
            return Fonts.fontRegular14
        case .author, .articleAuthor, .datestamp, .linkMenuComment, .linkMenuCommentRed,
             .articleTagTitle, .settingsTitle, .settingsTitleFade, .articleMarkRead:
            return Fonts.fontMedium12
        case .linkMenuItem, .myQOTBoxTitle:
            return Fonts.fontLight20
        case .audioBar, .articleAudioBar, .segmentHeading:
            return Fonts.fontSemiBold14
        case .articleCategory, .articleDatestamp:
            switch textScale {
            case .scale: return Fonts.fontMedium14
            case .scaleNot: return Fonts.fontMedium12
            }
        case .articleCategoryNotScaled:
            return Fonts.fontMedium12
        case .articleTitle:
            switch textScale {
            case .scale: return Fonts.fontLight40
            case .scaleNot: return Fonts.fontLight34
            }
        case .articleTitleNotScaled:
            return Fonts.fontLight34
        case .articleBullet:
            switch textScale {
            case .scale: return Fonts.fontLight24
            case .scaleNot: return Fonts.fontLight16
            }
        case .articleBody:
            switch textScale {
            case .scale: return Fonts.fontRegular24
            case .scaleNot: return Fonts.fontRegular16
            }
        case .articleRelatedTitle, .myQOTTitle, .whatsHotHeader,
             .articleHeadlineSmall, .articleHeadlineSmallRed, .articleHeadlineSmallFade, .articleHeadlineSmallLight,
             .chatButton, .chatButtonEnabled, .articleMediaDescription:
            return Fonts.fontLight16
        case .articleRelatedDetail:
            return Fonts.fontMedium12
        case .articleNextTitle:
            return Fonts.fontMedium14
        case .strategyHeader:
            return Fonts.fontRegular15

        case .articlePostTitle, .articlePostTitleNight:
            return Fonts.fontLight36
        case .articleSecondaryTitle:
            return Fonts.fontLight32
        case .articleSubTitle:
            return Fonts.fontLight24
        case .articleHeadline, .learnPDF:
            return Fonts.fontLight20
        case .articleNavigationTitle, .guideNavigationTitle, .calendarNoAccess:
            return Fonts.fontLight14
        case .articleTag, .articleTagSelected, .articleTagNight, .version, .placeholder,
             .articleParagraph, .learnVideo, .learnImage, .articleSector:
            return Fonts.fontLight11
        case .articleQuote:
            switch textScale {
            case .scale: return Fonts.fontLight20
            case .scaleNot: return Fonts.fontLight16
            }
        case .article:
            switch textScale {
            case .scale: return Fonts.fontRegular24
            case .scaleNot: return Fonts.fontRegular16
            }
        case .articleQuestion:
            return Fonts.fontLight19
        case .articleSub:
            return Fonts.fontLight18
        case .articleNum:
            return Fonts.fontLight72

        default:
            return Fonts.fontRegular20
        }
    }

    private var color: UIColor {
        switch self {
        case .navigationBarHeader,
             .sectionHeader, .categoryHeader, .categorySubHeader, .performanceTitle,
             .strategyHeader, .myQOTBoxTitle, .chatButtonEnabled, .settingsTitle,
             .searchTopic, .articleRelatedTitle:
            return Palette.sand
        case .author, .chatButton:
            return Palette.sand60
        case .datestamp, .performanceStaticTitle:
            return Palette.sand40
        case .linkMenuItem:
            return Palette.accent
        case .linkMenuComment, .strategySubHeader:
            return Palette.sand70
        case .linkMenuCommentRed:
            return Palette.redOrange
        case .searchExploreTopic, .settingsTitleFade, .searchBar:
            return Palette.sand40
        case .audioBar:
            return Palette.accent
        case .segmentHeading:
            return Palette.sand
        case .articleToolBarTint:
            return Palette.accent

        case .articleAudioBar, .articleMarkRead:
            return Palette.light(Palette.sand60, or: Palette.carbon60)
        case .articleCategory, .articleCategoryNotScaled:
            return Palette.light(Palette.carbon30, or: Palette.sand30)
        case .articleTitle, .articleTitleNotScaled, .articleBody, .myQOTTitle:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .whatsHotHeader(let mode):
            return Palette.light(Palette.carbon, or: Palette.sand, forcedColorMode: mode)
        case .articleAuthor(let mode):
            return Palette.light(Palette.carbon60, or: Palette.sand60, forcedColorMode: mode)
        case .articleDatestamp(let mode):
            return Palette.light(Palette.carbon30, or: Palette.sand30, forcedColorMode: mode)
        case .articleNextTitle:
            return Palette.light(Palette.carbon40, or: Palette.sand40)
        case .articlePostTitle, .articleSecondaryTitle, .articleSubTitle, .articleHeadline, .articleHeadlineSmall,
             .articleNavigationTitle, .articleTagTitle, .articleParagraph, .article,
             .articleQuestion, .articleSub, .articleNum, .articleSector:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .articleQuote, .articleMediaDescription:
            return Palette.light(Palette.carbon60, or: Palette.sand60)
        case .articleBullet:
            return Palette.light(Palette.carbon70, or: Palette.sand70)

        case .version, .articleRelatedDetail:
            return Palette.sand30

        case .articleHeadlineSmallRed:
            return Palette.cherryRed
        case .articleHeadlineSmallFade:
            return Palette.sand50
        case .articleHeadlineSmallLight:
            return Palette.sand10

        case .articleTag:
            return Palette.sand30
        case .articleTagSelected:
            return Palette.sand50

        case .articleTagNight:
            return Palette.nightModeSubFont
        case .articlePostTitleNight:
            return Palette.nightModeMainFont

        case .learnVideo:
            return Palette.nightModeBlack40
        case .learnImage, .learnPDF:
            return Palette.nightModeBlackTwo

        case .placeholder:
            return .sand10
        case .calendarNoAccess:
            return Palette.sand80
        case .guideNavigationTitle:
            return Palette.sand40
        }
    }

    func attributedString(_ input: String?, lineSpacing: CGFloat? = nil, lineHeight: CGFloat? = nil) -> NSAttributedString {
        let text = input != nil ? input! : ""
        let string: NSAttributedString

        switch self {
        case .navigationBarHeader, .articleCategory, .articleCategoryNotScaled, .articleAuthor, .articleDatestamp,
             .author, .articleMarkRead, .myQOTBoxTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.4, font: self.font, textColor: self.color, alignment: .left)
        case .performanceStaticTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.3, font: self.font, textColor: self.color, alignment: .left)
        case .linkMenuItem, .linkMenuComment, .linkMenuCommentRed:
            string = NSAttributedString(string: text, letterSpacing: 0.0, font: self.font, lineSpacing: 0, textColor: self.color, alignment: .left)
        case .articleTitle, .articleTitleNotScaled:
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

        case .articleBody, .articlePostTitle, .articleSecondaryTitle, .articleSubTitle, .articleHeadline,
             .articleParagraph, .articleSector, .articlePostTitleNight:
            let lSpace = lineSpacing != nil ? lineSpacing! : 1.0
            let lHeight = lineHeight != nil ? lineHeight! : 1.0
            string = NSAttributedString(string: text, letterSpacing: lSpace, font: self.font, lineSpacing: lHeight, textColor: self.color, alignment: .left)
        case .articleHeadlineSmall, .articleHeadlineSmallRed, .articleHeadlineSmallFade, .articleHeadlineSmallLight:
            let lSpace = lineSpacing != nil ? lineSpacing! : 0.0
            let lHeight = lineHeight != nil ? lineHeight! : 1.0
            string = NSAttributedString(string: text, letterSpacing: lSpace, font: self.font, lineSpacing: lHeight, textColor: self.color, alignment: .left)
        case .articleNavigationTitle, .article, .articleTag, .articleTagSelected, .version, .articleTagNight,
             .articleTagTitle, .articleMediaDescription, .calendarNoAccess, .placeholder:
            let lSpace = lineSpacing != nil ? lineSpacing! : 2.0
            let lHeight = lineHeight != nil ? lineHeight! : 1.0
            string = NSAttributedString(string: text, letterSpacing: lSpace, font: self.font, lineSpacing: lHeight, textColor: self.color, alignment: .left)
        case .articleQuote:
            let lSpace = lineSpacing != nil ? lineSpacing! : 1.0
            let lHeight = lineHeight != nil ? lineHeight! : 1.0
            string = NSAttributedString(string: text, letterSpacing: lSpace, font: self.font, lineSpacing: lHeight, textColor: self.color, alignment: .right)
        case .articleQuestion, .articleSub, .articleNum:
            let lSpace = lineSpacing != nil ? lineSpacing! : 1.0
            let lHeight = lineHeight != nil ? lineHeight! : 1.0
            string = NSAttributedString(string: text, letterSpacing: lSpace, font: self.font, lineSpacing: lHeight, textColor: self.color, alignment: .center)
        case .chatButton, .chatButtonEnabled:
            string = NSAttributedString(string: text, font: self.font, lineSpacing: 2.0, textColor: self.color, alignment: .left)
        case .settingsTitle, .settingsTitleFade:
            string = NSAttributedString(string: text, font: self.font, textColor: self.color, alignment: .left)
        default:
            string = NSAttributedString(string: "<NO THEME - \(self)>")
        }
        return string
    }

    func apply(_ text: String?, to view: UILabel, lineSpacing: CGFloat? = nil, lineHeight: CGFloat? = nil) {
        let string = attributedString(text, lineSpacing: lineSpacing, lineHeight: lineHeight)
        if string.string.contains("<NO THEME") {
            view.backgroundColor = .red
        } else {
            view.attributedText = string
            view.backgroundColor = .clear

            switch self {
            case .settingsTitle, .settingsTitleFade:
                view.lineBreakMode = .byTruncatingTail
            default:
                break
            }
        }
    }
}

private struct Fonts {
    static let fontRegular14 = UIFont.sfProtextRegular(ofSize: 14.0)
    static let fontRegular15 = UIFont.sfProtextRegular(ofSize: 15.0)
    static let fontRegular16 = UIFont.sfProtextRegular(ofSize: 16.0)
    static let fontRegular20 = UIFont.sfProtextRegular(ofSize: 20.0)
    static let fontRegular24 = UIFont.sfProtextRegular(ofSize: 24.0)

    static let fontMedium12 = UIFont.sfProtextMedium(ofSize: 12.0)
    static let fontMedium14 = UIFont.sfProtextMedium(ofSize: 14.0)
    static let fontMedium20 = UIFont.sfProtextMedium(ofSize: 20.0)

    static let fontLight11 = UIFont.sfProtextLight(ofSize: 11.0)
    static let fontLight14 = UIFont.sfProtextLight(ofSize: 14.0)
    static let fontLight16 = UIFont.sfProtextLight(ofSize: 16.0)
    static let fontLight18 = UIFont.sfProtextLight(ofSize: 18.0)
    static let fontLight19 = UIFont.sfProtextLight(ofSize: 19.0)
    static let fontLight20 = UIFont.sfProtextLight(ofSize: 20.0)
    static let fontLight24 = UIFont.sfProtextLight(ofSize: 24.0)
    static let fontLight32 = UIFont.sfProtextLight(ofSize: 32.0)
    static let fontLight34 = UIFont.sfProtextLight(ofSize: 34.0)
    static let fontLight36 = UIFont.sfProtextLight(ofSize: 36.0)
    static let fontLight40 = UIFont.sfProtextLight(ofSize: 40.0)
    static let fontLight72 = UIFont.sfProtextLight(ofSize: 72.0)

    static let fontSemiBold14 = UIFont.sfProtextSemibold(ofSize: 14.0)
}

private struct Palette {
    static var accent: UIColor {
        return UIColor(red: 182/255, green: 155/255, blue: 134/255, alpha: 1)
    }

    static var accent04: UIColor {
        return UIColor.accent.withAlphaComponent(0.04)
    }

    static var accent10: UIColor {
        return UIColor.accent.withAlphaComponent(0.1)
    }

    static var accent30: UIColor {
        return UIColor.accent.withAlphaComponent(0.3)
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

    static var sand50: UIColor {
        return UIColor.sand.withAlphaComponent(0.4)
    }

    static var sand60: UIColor {
        return UIColor.sand.withAlphaComponent(0.6)
    }

    static var sand70: UIColor {
        return UIColor.sand.withAlphaComponent(0.7)
    }

    static var sand80: UIColor {
        return UIColor.sand.withAlphaComponent(0.8)
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

    static var carbon70: UIColor {
        return UIColor.carbon.withAlphaComponent(0.7)
    }

    static var redOrange: UIColor {
        return UIColor(red: 238/255, green: 94/255, blue: 85/255, alpha: 1)
    }

    static var cherryRed: UIColor {
        return UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 1)
    }

    static var darkIndigo: UIColor {
        return UIColor(red: 4/255, green: 8/255, blue: 20/255, alpha: 1)
    }

    static var azure: UIColor {
        return UIColor(red: 1/255, green: 148/255, blue: 255/255, alpha: 1)
    }

    static var navy: UIColor {
        return UIColor(red: 2/255, green: 18/255, blue: 33/255, alpha: 1)
    }

    static var blackTwo: UIColor {
        return UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
    }

    static var nightModeBackground: UIColor {
        return Date().isNight ? Palette.navy : Palette.sand
    }

    static var nightModeMainFont: UIColor {
        return Date().isNight ? Palette.sand : Palette.darkIndigo
    }

    static var nightModeSubFont: UIColor {
        return Date().isNight ? Palette.sand : Palette.carbon30
    }

    static var nightModeBlack: UIColor {
        return Date().isNight ? Palette.sand : Palette.carbon
    }

    static var nightModeBlack30: UIColor {
        return Date().isNight ? Palette.sand70 : Palette.carbon30
    }

    static var nightModeBlack40: UIColor {
        return Date().isNight ? Palette.sand : Palette.carbon40
    }

    static var nightModeBlackTwo: UIColor {
        return Date().isNight ? Palette.sand : Palette.blackTwo
    }

    static var nightModeBlack15: UIColor {
        return Date().isNight ? Palette.sand80 : Palette.carbon10
    }

    static var nightModeBlue: UIColor {
        return Date().isNight ? Palette.azure : .blue
    }

    static func light(_ lightColor: UIColor, or darkColor: UIColor, forcedColorMode: ThemeColorMode? = nil) -> UIColor {
        if let forcedColorMode = forcedColorMode {
            switch forcedColorMode {
            case .dark: return darkColor
            case .light: return lightColor
            }
        } else {
            switch colorMode {
            case .dark: return darkColor
            case .darkNot: return lightColor
            }
        }
    }
}
