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
        bar?.isTranslucent = false
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
    case sprints
    case level1Secondary
    case level1Selected
    case level2Selected
    case onboarding
    case article
    case articleBackground(ThemeColorMode?)
    case articleSeparator(ThemeColorMode?)
    case articleAudioBar
    case articleMarkRead
    case articleMarkUnread
    case audioBar
    case fade
    case separator
    case accentBackground
    case headerLine
    case prepsSegmentSelected
    case qotAlert
    case imageOverlap
    case qSearch
    case chatbot
    case toolSeparator
    case askPermissions
    case resultWhite
    case qotTools
    case syncedCalendarSeparator
    case audioPlaying
    case tbvLowPerformance
    case myDataHeatMapLegendHigh
    case myDataHeatMapLegendLow

    var color: UIColor {
        switch self {
        case .level1:
            return Palette.carbon
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
        case .audioPlaying:
            return Palette.accent40
        case .onboarding:
            return Palette.carbon
        case .toolSeparator:
            return Palette.carbon10
        case .article:
            return Palette.light(Palette.sand, or: Palette.carbon)
        case .articleBackground(let mode):
            return Palette.light(Palette.sand, or: Palette.carbon, forcedColorMode: mode)
        case .articleSeparator(let mode):
            return Palette.light(Palette.carbon10, or: Palette.sand10, forcedColorMode: mode)
        case .articleAudioBar:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .audioBar, .headerLine, .qSearch, .chatbot, .qotTools:
            return Palette.sand
        case .fade:
            return Palette.light(Palette.sand10, or: Palette.carbon10)
        case .separator:
            return Palette.light(Palette.carbon10, or: Palette.sand10)
        case .articleMarkRead, .articleMarkUnread:
            return Palette.light(Palette.sand, or: Palette.carbon)
        case .accentBackground, .prepsSegmentSelected:
            return Palette.accent30
        case .qotAlert, .sprints:
            return Palette.carbonDark80
        case .imageOverlap:
            return Palette.carbon60
        case .askPermissions:
            return Palette.carbon
        case .resultWhite:
            return Palette.white40
        case .syncedCalendarSeparator:
            return Palette.sand40
        case .tbvLowPerformance:
            return Palette.carbon70
        case .myDataHeatMapLegendHigh:
            return Palette.heatMapBrightRed
        case .myDataHeatMapLegendLow:
            return Palette.heatMapDarkBlue
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
    case accent40

    func apply(_ view: UIView) {
        var color: UIColor?
        switch self {
        case .accent:
            color = Palette.accent
        case .accentBackground:
            color = Palette.accent30
        case .accent40:
            color = Palette.accent40
        }

        if let color = color {
            view.layer.borderWidth = 1
            view.layer.borderColor = color.cgColor
            view.corner(radius: view.frame.size.height / 2)
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

enum ThemeSwitch {
    case accent
    case white

    func apply(_ view: UISwitch) {
        switch self {
        case .accent:
            view.tintColor = Palette.accent70
            view.onTintColor = Palette.accent70
            view.layer.borderColor = Palette.accent70.cgColor
        case .white:
            view.tintColor = Palette.white40
            view.onTintColor = .clear
            view.layer.borderColor = Palette.white40.cgColor
        }
    }
}

enum ThemeButton {
    case accent40
    case audioButton
    case closeButton(ThemeColorMode)

    var defaultHeight: CGFloat {
        get {
            switch self {
            default:
                return 40.0
            }
        }
    }

    func apply(_ button: UIButton, selected: Bool = false, selectedImage: UIImage? = nil, unSelectedImage: UIImage? = nil) {
        var colorSelected: UIColor = .clear
        var colorUnselected: UIColor = .clear
        var colorBorder: UIColor?
        switch self {
        case .accent40:
            colorSelected = Palette.accent40
            colorBorder = Palette.accent40
        case .audioButton:
            colorSelected = Palette.light(Palette.sand, or: Palette.carbon)
            colorUnselected = colorSelected
            colorBorder = .accent40
        case .closeButton(let mode):
            colorSelected = Palette.light(Palette.sand, or: Palette.carbon, forcedColorMode: mode)
            colorUnselected = colorSelected
            colorBorder = .accent40
        }

        if let color = colorBorder {
            button.layer.borderWidth = selected ? 0 : 1
            button.layer.borderColor = selected ? UIColor.clear.cgColor : color.cgColor
        }

        let bounds = button.bounds
        let side = bounds.height > bounds.width ? bounds.width : bounds.height
        button.corner(radius: side / 2)
        button.backgroundColor = selected ? colorSelected : colorUnselected
    }
}

enum ThemeCircles {
    case fullScreenAudioLight
    case fullScreenAudioDark

    var circles: [CircleInfo] {
        switch self {
        case .fullScreenAudioDark:
            return [
                CircleInfo(color: .sand70, radiusRate: 0.2),
                CircleInfo(color: .sand60, radiusRate: 0.4),
                CircleInfo(color: .sand40, radiusRate: 0.7),
                CircleInfo(color: .sand20, radiusRate: 0.99)
            ]
        case .fullScreenAudioLight:
            return [
                CircleInfo(color: .accent70, radiusRate: 0.2),
                CircleInfo(color: .accent60, radiusRate: 0.4),
                CircleInfo(color: .accent40, radiusRate: 0.7),
                CircleInfo(color: .accent20, radiusRate: 0.99)
            ]
        }
    }

    func apply(_ circleView: FullScreenBackgroundCircleView) {
        circleView.circles = circles
    }
}

enum ThemableButton {
    case myLibrary
    case fullscreenAudioPlayerDownload
    case fullscreenAudioPlayerDownloadLight
    case fullscreenVideoPlayerDownload
    case myLibraryNotes
    case askPermissions
    case syncedCalendar

    var titleAttributes: [NSAttributedStringKey: Any]? {
        switch self {
        case .myLibrary,
             .fullscreenAudioPlayerDownload,
             .fullscreenVideoPlayerDownload,
             .myLibraryNotes,
             .askPermissions,
             .fullscreenAudioPlayerDownloadLight,
             .syncedCalendar:
            return [.font: UIFont.sfProtextSemibold(ofSize: 14), .kern: 0.2]
        }
    }

    var normal: ButtonTheme? {
        switch self {
        case .myLibrary, .askPermissions, .syncedCalendar:
            return ButtonTheme(foreground: .accent, background: .carbon, border: .accent30)
        case .myLibraryNotes:
            return ButtonTheme(foreground: .accent, background: .carbonNew, border: .accent30)
        case .fullscreenAudioPlayerDownload, .fullscreenVideoPlayerDownload:
            return ButtonTheme(foreground: .accent, background: .carbonNew80, border: .accent40)
        case .fullscreenAudioPlayerDownloadLight:
            return ButtonTheme(foreground: .accent, background: .sand, border: .accent40)
        }
    }

    var highlight: ButtonTheme? {
        switch self {
        case .myLibrary, .askPermissions, .syncedCalendar:
            return ButtonTheme(foreground: .accent70, background: .carbon, border: .accent10)
        case .myLibraryNotes:
            return ButtonTheme(foreground: .accent70, background: .carbonNew, border: .accent10)
        case .fullscreenAudioPlayerDownload, .fullscreenVideoPlayerDownload:
            return ButtonTheme(foreground: .accent70, background: .carbonNew80, border: .accent10)
        case .fullscreenAudioPlayerDownloadLight:
            return ButtonTheme(foreground: .accent70, background: .accent40, border: .accent40)

        }
    }

    var select: ButtonTheme? {
        switch self {
        case .fullscreenAudioPlayerDownload, .fullscreenVideoPlayerDownload:
            return ButtonTheme(foreground: .accent, background: .accent40, border: nil)
        case .fullscreenAudioPlayerDownloadLight:
            return ButtonTheme(foreground: .accent, background: .accent40, border: nil)
        default:
            return nil
        }
    }

    var disabled: ButtonTheme? {
        switch self {
        case .myLibrary:
            return ButtonTheme(foreground: .sand08, background: .carbon, border: .sand08)
        case .myLibraryNotes:
            return ButtonTheme(foreground: .sand08, background: .carbonNew80, border: .accent10)
        case .fullscreenAudioPlayerDownload, .fullscreenVideoPlayerDownload:
            return ButtonTheme(foreground: .accent, background: .accent40, border: nil)
        case .fullscreenAudioPlayerDownloadLight:
            return ButtonTheme(foreground: .accent, background: .accent40, border: nil)
        default:
            return nil
        }
    }

    func apply(_ button: ButtonThemeable, title: String?) {
        var button = button
        button.titleAttributes = titleAttributes
        button.normal = normal
        button.highlight = highlight
        button.select = select
        button.disabled = disabled
        button.setTitle(title)
    }

    func apply(_ button: ButtonThemeable, title: NSAttributedString) {
        var button = button
        button.titleAttributes = titleAttributes
        button.normal = normal
        button.highlight = highlight
        button.select = select
        button.disabled = disabled
        button.setAttributedTitle(title)
    }
}

enum ThemeSegment {
    case accent

    func apply(_ view: UISegmentedControl) {
        var normal: [NSAttributedString.Key: Any]?
        var selected: [NSAttributedString.Key: Any]?

        switch self {
        case .accent:
            normal = [NSAttributedStringKey.font: Fonts.fontRegular14,
                      NSAttributedStringKey.foregroundColor: Palette.accent60]
            selected = [NSAttributedStringKey.font: Fonts.fontRegular14,
                        NSAttributedStringKey.foregroundColor: Palette.sand]
            view.tintColor = .clear
            view.backgroundColor = .carbon
        }

        if let normal = normal,
            let selected = selected {
            view.setTitleTextAttributes(normal, for: .normal)
            view.setTitleTextAttributes(selected, for: .selected)
        } else {
            view.backgroundColor = .red
        }
    }
}

enum ThemeSearchBar {
    case accent

    func apply(_ view: UISearchBar) {
        switch self {
        case .accent:
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).isEnabled = true
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = Palette.accent

            view.tintColor = Palette.accent
            view.keyboardAppearance = .dark
            if let searchField = view.value(forKey: "_searchField") as? UITextField {
                searchField.corner(radius: 20)
                searchField.backgroundColor = Palette.sand10
                searchField.textColor = Palette.sand
            }
            view.setShowsCancelButton(true, animated: false)
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
    case linkMenuComment        //???
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
    case articleRelatedTitle(ThemeColorMode?)
    case articleRelatedTitleInStrategy
    case articleRelatedDetail(ThemeColorMode?)
    case articleRelatedDetailInStrategy
    case articleNextTitle
    case audioPlayerTitleDark
    case audioPlayerTitleLight
    case audioPlayerTime
    case audioPlayerTimeLight

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
    case coachHeader
    case coachHeaderSubtitle
    case coachTitle
    case coachSubtitle

    case settingsTitle
    case settingsTitleFade

    case strategyHeader
    case strategySubHeader
    case myQOTBoxTitle
    case myQOTTitle
    case myQOTProfileName
    case myQOTPrepCellTitle
    case myQOTPrepTitle
    case myQOTPrepComment
    case myQOTSectionHeader
    case accountHeader
    case accountDetail
    case accountUserName
    case accountHeaderTitle
    case quotation
    case quotationSmall
    case quotationLight
    case quotationSlash
    case dailyBriefTitle
    case dailyBriefSubtitle
    case sprintName
    case quoteAuthor
    case sprintText
    case sprintTitle
    case durationString
    case solveQuestions
    case tbvStatement
    case solveFuture
    case level5Question
    case performanceBucketTitle
    case performanceSubtitle
    case performanceSections
    case performanceSectionText
    case bespokeTitle
    case bespokeText
    case leaderText
    case leaderVideoTitle
    case strategyTitle
    case fromCoachTitle
    case goodToKnow
    case readinessScore
    case asterix
    case impactBucket
    case sleepReference
    case reference
    case qotAlertTitle
    case qotAlertMessage
    case searchResult
    case searchContent
    case searchSuggestionHeader
    case searchSuggestion
    case questionHintLabel
    case questionHintLabelDark
    case questionHintLabelRed

    case onboardingInputText
    case onboardingInputPlaceholder
    case loginEmailTitle
    case loginEmailMessage
    case loginEmailErrorMessage
    case loginEmailCode
    case loginEmailCodeMessage
    case loginEmailCodeErrorMessage
    case createAccountMessage
    case registrationEmailTitle
    case registrationEmailMessage
    case registrationEmailError
    case registrationCodeTitle
    case registrationCodeDescription
    case registrationCodeDescriptionEmail
    case registrationCodePreCode
    case registrationCodeError
    case registrationCodeDisclaimerError
    case registrationCodeTermsAndPrivacy
    case registrationCodeInfoActions
    case registrationCodeLink(String)
    case registrationNamesTitle
    case registrationNamesMandatory
    case registrationAgeTitle
    case registrationAgeDescription
    case registrationAgeRestriction
    case locationPermissionTitle
    case locationPermissionMessage
    case trackSelectionTitle
    case trackSelectionMessage
    case walkthroughMessage

    case tbvSectionHeader
    case tbvHeader
    case tbvVision
    case tbvButton
    case tbvBody
    case tbvVisionHeader
    case tbvVisionBody
    case tvbTimeSinceTitle
    case tvbCounter
    case tbvTrackerHeader
    case tbvTrackerBody
    case tbvTrackerAnswer
    case tbvTrackerRating
    case tbvTrackerRatingDigits
    case tbvTrackerRatingDigitsSelected
    case tbvQuestionLight
    case tbvQuestionMedium
    case qotTools
    case qotToolsSubtitle
    case qotToolsTitle
    case qotToolsSectionSubtitle
    case audioLabel

    case myDataSectionHeaderTitle
    case myDataSectionHeaderSubTitle
    case myDataMonthYearTitle
    case myDataWeekdaysNotHighlighted(Bool)
    case myDataWeekdaysHighlighted(Bool)
    case myDataSwitchButtons
    case myDataChartValueLabels
    case myDataChartIRAverageLabel
    case myDataParameterLegendText(MyDataParameter)
    case myDataParameterSelectionTitle(MyDataParameter)
    case myDataParameterExplanationTitle(MyDataParameter)
    case myDataExplanationCellSubtitle
    case myDataHeatMapLegendText
    case myDataHeatMapCellDateText
    case myDataHeatMapCellDateHighlighted
    case myDataHeatMapDetailCellValue
    case myDataHeatMapDetailCellDate
    case dailyBriefLevelContent
    case dailyBriefLevelTitle
    case dailyBriefTitleBlack
    case dailyBriefDailyCheckInSights
    case dailyBriefDailyCheckInClosedBucket
    case accountDetailEmail
    case accountDetailAge

    case chatBotButton

    case resultDate
    case resultTitle
    case resultHeader1
    case resultHeader2
    case resultList
    case resultListHeader
    case resultFollowUp
    case askPermissionTitle
    case askPermissionMessage
    case resultCounter
    case resultCounterMax

    case syncedCalendarTitle
    case syncedCalendarDescription
    case syncedCalendarTableHeader
    case syncedCalendarRowTitle
    case syncedCalendarRowSubtitle

    case weatherIntro
    case weatherDescription
    case weatherTitle
    case weatherBody
    case weatherHourlyLabels
    case weatherHourlyLabelNow

    private var font: UIFont {
        switch self {
        case .registrationCodeDisclaimerError, .resultCounterMax:
            return Fonts.fontRegular12
        case .asterix:
            return Fonts.fontRegular13
        case .navigationBarHeader, .sectionHeader, .categoryHeader, .fromCoachTitle, .myQOTSectionHeader, .tbvTrackerHeader, .myDataSectionHeaderTitle, .dailyBriefDailyCheckInClosedBucket,
          .askPermissionTitle, .syncedCalendarTitle, .weatherTitle:
            return Fonts.fontRegular20
        case .categorySubHeader, .searchTopic, .solveFuture, .level5Question, .performanceSectionText, .goodToKnow, .bespokeText, .leaderText, .tbvVision, .tbvVisionBody, .myDataMonthYearTitle,
             .myDataExplanationCellSubtitle, .myDataHeatMapDetailCellDate, .registrationCodeDescription, .registrationCodePreCode, .registrationAgeDescription,
             .locationPermissionMessage, .accountDetail, .dailyBriefDailyCheckInSights, .quotationLight, .askPermissionMessage,
             .weatherIntro, .weatherDescription, .weatherBody, .dailyBriefSubtitle:
            return Fonts.fontRegular16
        case .leaderVideoTitle, .searchExploreTopic, .searchBar,
             .performanceSubtitle, .quoteAuthor, .sleepReference, .reference, .searchResult, .searchSuggestion, .tbvTrackerBody, .loginEmailMessage,
             .loginEmailErrorMessage, .loginEmailCode, .loginEmailCodeMessage, .loginEmailCodeErrorMessage,
             .tbvTrackerRatingDigits, .myDataSectionHeaderSubTitle, .registrationEmailMessage, .registrationEmailError,
             .registrationCodeError, .registrationCodeTermsAndPrivacy, .registrationCodeInfoActions, .registrationNamesMandatory,
             .registrationAgeRestriction, .trackSelectionMessage, .questionHintLabel, .questionHintLabelDark, .questionHintLabelRed, .audioPlayerTitleDark, .audioPlayerTitleLight,
             .weatherHourlyLabels, .weatherHourlyLabelNow, .accountHeader:
            return Fonts.fontRegular14
        case .author, .datestamp, .articleAuthor, .linkMenuComment, .linkMenuCommentRed, .articleRelatedDetail, .articleRelatedDetailInStrategy, .durationString,
             .resultDate, .resultFollowUp,
             .articleTagTitle, .settingsTitle, .settingsTitleFade, .articleMarkRead, .myDataChartValueLabels:
            return Fonts.fontMedium12
        case .linkMenuItem, .myQOTBoxTitle, .myQOTPrepTitle:
            return Fonts.fontLight20
        case .readinessScore:
            return Fonts.fontDisplayUltralight64
        case .chatBotButton, .audioBar, .articleAudioBar, .segmentHeading, .tbvButton, .myDataSwitchButtons, .myDataWeekdaysHighlighted, .registrationCodeLink:
            return Fonts.fontSemiBold14
        case .registrationCodeDescriptionEmail, .walkthroughMessage:
            return Fonts.fontSemiBold16
        case .articleCategory, .articleDatestamp:
            switch textScale {
            case .scale: return Fonts.fontMedium14
            case .scaleNot: return Fonts.fontMedium12
            }
        case .strategyTitle:
            return Fonts.fontDisplayThin30
        case .bespokeTitle, .onboardingInputText, .onboardingInputPlaceholder:
            return Fonts.fontRegular18
        case .sprintName, .performanceBucketTitle, .myDataHeatMapCellDateText, .tbvQuestionMedium, .resultListHeader:
            return Fonts.fontMedium16
        case .articleCategoryNotScaled, .qotToolsSectionSubtitle:
            return Fonts.fontMedium12
        case .articleTitle:
            switch textScale {
            case .scale: return Fonts.fontLight40
            case .scaleNot: return Fonts.fontLight34
            }
        case .articleTitleNotScaled, .tbvHeader, .tbvVisionHeader:
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
        case .articleRelatedTitle, .articleRelatedTitleInStrategy, .myQOTTitle, .whatsHotHeader, .sprintText, .sprintTitle, .solveQuestions, .impactBucket,
             .chatButton, .chatButtonEnabled, .articleMediaDescription, .articleHeadlineSmall, .articleHeadlineSmallRed,
             .articleHeadlineSmallFade, .articleHeadlineSmallLight, .myQOTPrepCellTitle, .myQOTPrepComment,
             .tbvBody, .tvbTimeSinceTitle, .tbvTrackerAnswer, .accountHeaderTitle,
             .resultTitle, .resultHeader2,
             .dailyBriefLevelTitle, .strategySubHeader, .tbvQuestionLight,
             .coachSubtitle, .coachHeaderSubtitle, .dailyBriefLevelContent,
             .qotTools, .qotToolsSubtitle, .syncedCalendarRowTitle, .accountDetailEmail, .accountDetailAge:
            return Fonts.fontLight16
        case .articleNextTitle, .performanceSections, .searchSuggestionHeader, .tbvSectionHeader,
             .tbvTrackerRating, .tbvTrackerRatingDigitsSelected, .performanceStaticTitle, .resultList,
             .syncedCalendarRowSubtitle, .syncedCalendarTableHeader, .syncedCalendarDescription:
            return Fonts.fontMedium14
        case .strategyHeader, .coachTitle:
            return Fonts.fontDisplayRegular20
        case .quotation:
            return Fonts.fontDisplayThin34
        case .dailyBriefTitle, .loginEmailTitle, .registrationEmailTitle, .registrationCodeTitle, .registrationNamesTitle,
             .registrationAgeTitle, .locationPermissionTitle, .trackSelectionTitle, .dailyBriefTitleBlack:
            return Fonts.fontDisplayRegular20
        case .tbvStatement, .qotToolsTitle, .resultHeader1, .coachHeader, .accountUserName:
            return Fonts.fontDisplayLight24
        case .articlePostTitle, .articlePostTitleNight:
            return Fonts.fontLight36
        case .articleSecondaryTitle:
            return Fonts.fontLight32
        case .articleSubTitle, .myQOTProfileName, .quotationSlash:
            return Fonts.fontLight24
        case .articleHeadline, .learnPDF:
            return Fonts.fontLight20
        case .articleNavigationTitle, .guideNavigationTitle, .calendarNoAccess, .myDataWeekdaysNotHighlighted,
             .quotationSmall:
            return Fonts.fontLight14
        case .articleTag, .articleTagSelected, .articleTagNight, .version, .placeholder,
             .articleParagraph, .learnVideo, .learnImage, .articleSector, .searchContent:
            return Fonts.fontLight11
        case .audioLabel:
            return Fonts.fontSemiBold12
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
        case .qotAlertTitle:
            return Fonts.fontLight20
        case .qotAlertMessage, .myDataParameterSelectionTitle:
            return Fonts.fontRegular14
        case .tvbCounter:
            return Fonts.fontDisplayUltralight120
        case .myDataHeatMapLegendText, .myDataParameterLegendText:
            return Fonts.fontRegular12
        case .myDataHeatMapDetailCellValue:
            return Fonts.fontDisplayThin34
        case .myDataChartIRAverageLabel, .resultCounter, .audioPlayerTime, .audioPlayerTimeLight:
            return Fonts.fontSemiBold12
        case .myDataHeatMapCellDateHighlighted:
            return Fonts.fontSemiBold16
        case .myDataParameterExplanationTitle:
            return Fonts.fontRegular20
        default:
            return Fonts.fontRegular20
        }
    }

    private var color: UIColor {
        switch self {
        case .navigationBarHeader, .quotation, .dailyBriefTitle, .segmentHeading, .searchTopic, .asterix, .impactBucket,
             .articleRelatedTitleInStrategy, .sectionHeader, .categoryHeader, .categorySubHeader, .performanceTitle, .bespokeTitle,
             .chatButtonEnabled, .settingsTitle, .strategyHeader, .myQOTBoxTitle, .sprintName, .sprintTitle, .solveQuestions,
             .tbvStatement, .level5Question, .leaderText, .leaderVideoTitle, .myQOTProfileName, .myQOTTitle,
             .myQOTPrepCellTitle, .myQOTSectionHeader, .myQOTPrepTitle, .searchResult, .onboardingInputText,
             .tbvVisionHeader, .tbvVisionBody, .tvbTimeSinceTitle, .tvbCounter, .tbvTrackerHeader, .tbvTrackerRating, .questionHintLabel,
             .tbvTrackerRatingDigitsSelected, .loginEmailTitle, .myDataSectionHeaderTitle, .myDataMonthYearTitle, .myDataWeekdaysHighlighted,
             .myDataHeatMapDetailCellValue, .myDataHeatMapCellDateHighlighted, .registrationEmailTitle, .registrationCodeTitle,
             .dailyBriefLevelTitle, .searchSuggestion,
             .registrationNamesTitle, .registrationAgeTitle, .locationPermissionTitle, .trackSelectionTitle, .walkthroughMessage, .dailyBriefLevelContent, .dailyBriefDailyCheckInClosedBucket, .quotationSmall,
             .tbvQuestionLight, .tbvQuestionMedium, .askPermissionTitle, .syncedCalendarTitle, .syncedCalendarRowTitle,
             .weatherTitle, .weatherHourlyLabelNow, .accountUserName, .accountDetailAge:
            return Palette.sand
        case .quoteAuthor, .chatButton, .myDataChartValueLabels, .myDataHeatMapLegendText, .bespokeText, .accountDetailEmail, .dailyBriefSubtitle:
            return Palette.sand60
        case .datestamp, .performanceStaticTitle, .durationString, .solveFuture, .searchExploreTopic, .searchBar, .reference,
             .settingsTitleFade, .searchContent, .searchSuggestionHeader, .tbvVision, .tbvSectionHeader, .tbvTrackerRatingDigits,
             .myDataChartIRAverageLabel, .registrationNamesMandatory, .accountDetail, .quotationLight, .quotationSlash,
             .audioPlayerTime, .syncedCalendarRowSubtitle, .syncedCalendarTableHeader, .syncedCalendarDescription, .accountHeader:
            return Palette.sand40
        case .performanceSubtitle:
            return Palette.carbonDark40
        case .linkMenuItem, .audioBar, .performanceBucketTitle, .articleToolBarTint, .strategyTitle, .sleepReference, .tbvButton,
             .myDataSwitchButtons, .registrationCodeLink, .accountHeaderTitle, .articleMarkRead, .articleAudioBar, .coachTitle, .audioLabel, .chatBotButton:
            return Palette.accent
        case .performanceSections, .resultList, .resultFollowUp, .audioPlayerTimeLight, .resultListHeader,
             .resultCounter, .resultCounterMax:
            return Palette.carbon40
        case .fromCoachTitle, .dailyBriefTitleBlack, .qotTools, .qotToolsTitle, .questionHintLabelDark, .coachHeader,
             .resultTitle, .resultHeader1:
            return Palette.carbon
        case .linkMenuComment, .strategySubHeader, .sprintText, .goodToKnow, .readinessScore,
             .myQOTPrepComment, .tbvHeader, .tbvBody, .tbvTrackerBody, .tbvTrackerAnswer, .loginEmailMessage, .loginEmailCode,
             .loginEmailCodeMessage, .myDataSectionHeaderSubTitle, .myDataWeekdaysNotHighlighted, .myDataHeatMapCellDateText,
             .myDataExplanationCellSubtitle, .myDataHeatMapDetailCellDate, .onboardingInputPlaceholder, .createAccountMessage,
             .registrationEmailMessage, .registrationCodeDescription, .registrationCodeDescriptionEmail, .trackSelectionMessage,
             .registrationCodePreCode, .registrationCodeTermsAndPrivacy, .registrationCodeInfoActions, .registrationAgeDescription,
             .registrationAgeRestriction, .locationPermissionMessage, .author, .dailyBriefDailyCheckInSights, .audioPlayerTitleLight, .askPermissionMessage,
             .weatherIntro, .weatherDescription, .weatherBody, .weatherHourlyLabels:
            return Palette.sand70
        case .performanceSectionText, .qotToolsSectionSubtitle, .resultHeader2,
             .audioPlayerTitleDark, .coachHeaderSubtitle, .coachSubtitle, .qotToolsSubtitle:
            return Palette.carbon70
        case .linkMenuCommentRed, .loginEmailErrorMessage, .loginEmailCodeErrorMessage, .registrationEmailError,
             .registrationCodeDisclaimerError:
            return Palette.redOrange
        case .questionHintLabelRed:
            return .red
        case .articleCategory, .articleCategoryNotScaled:
             return Palette.light(Palette.carbon30, or: Palette.sand30)
        case .articleTitle, .articleTitleNotScaled, .articleBody:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .articleDatestamp, .articleRelatedDetailInStrategy:
            return Palette.light(Palette.carbon30, or: Palette.sand30)
        case .articleNextTitle:
            return Palette.light(Palette.carbon40, or: Palette.sand40)
        case .whatsHotHeader(let mode),
             .articleRelatedTitle(let mode):
            return Palette.light(Palette.carbon, or: Palette.sand, forcedColorMode: mode)
        case .articleRelatedDetail(let mode):
            return Palette.light(Palette.carbon30, or: Palette.sand30, forcedColorMode: mode)
        case .articleAuthor(let mode):
            return Palette.light(Palette.carbon60, or: Palette.sand60, forcedColorMode: mode)
        case .articlePostTitle, .articleSecondaryTitle, .articleSubTitle, .articleHeadline, .articleHeadlineSmall,
             .articleNavigationTitle, .articleTagTitle, .articleParagraph, .article,
             .articleQuestion, .articleSub, .articleNum, .articleSector:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .articleQuote, .articleMediaDescription:
            return Palette.light(Palette.carbon60, or: Palette.sand60)
        case .articleBullet:
            return Palette.light(Palette.carbon70, or: Palette.sand70)
        case .version:
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
        case .registrationCodeError:
            return Palette.redOrange70
        case .placeholder:
            return .sand10
        case .calendarNoAccess:
            return Palette.sand80
        case .guideNavigationTitle:
            return Palette.sand40
        case .qotAlertTitle:
            return Palette.sand
        case .qotAlertMessage:
            return Palette.sand70
        case .resultDate:
            return Palette.carbon30
        case .myDataParameterLegendText(let parameter), .myDataParameterSelectionTitle(let parameter), .myDataParameterExplanationTitle(let parameter):
            return Palette.parameterColor(for: parameter)
        }
    }

    func attributedString(_ input: String?, lineSpacing: CGFloat? = nil, lineHeight: CGFloat? = nil) -> NSAttributedString {
        let text = input != nil ? input! : ""
        let string: NSAttributedString

        switch self {
        case .navigationBarHeader, .articleCategory, .articleCategoryNotScaled, .articleAuthor, .articleDatestamp,
             .author, .articleMarkRead, .myQOTBoxTitle, .durationString, .tbvStatement, .dailyBriefTitle, .strategyTitle, .dailyBriefTitleBlack,
             .myQOTPrepTitle, .tbvTrackerHeader, .dailyBriefDailyCheckInSights, .quotationLight, .quotationSlash,
             .resultFollowUp, .audioPlayerTime, .audioPlayerTimeLight, .qotToolsSectionSubtitle, .qotToolsTitle,
             .coachHeader, .coachTitle, .syncedCalendarTitle, .accountUserName, .accountHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.4, font: self.font, textColor: self.color, alignment: .left)
        case .articleTitle, .articleTitleNotScaled, .performanceSections, .audioLabel, .bespokeTitle, .audioPlayerTitleDark, .audioPlayerTitleLight:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 4, textColor: self.color, alignment: .left)
        case .strategyHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.3, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .performanceStaticTitle, .fromCoachTitle, .resultDate:
            string = NSAttributedString(string: text, letterSpacing: 0.3, font: self.font, textColor: self.color, alignment: .left)
        case .sprintTitle, .leaderVideoTitle, .searchSuggestion, .tbvBody, .tvbTimeSinceTitle, .tbvTrackerAnswer, .qotTools,
             .resultTitle, .resultListHeader, .resultHeader1, .resultHeader2, .resultList, .coachHeaderSubtitle, .coachSubtitle,
             .qotToolsSubtitle, .syncedCalendarRowTitle, .syncedCalendarRowSubtitle, .accountDetailEmail, .accountDetailAge:
             string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, textColor: self.color, alignment: .left)
        case .datestamp, .linkMenuComment, .linkMenuItem, .linkMenuCommentRed, .performanceBucketTitle, .goodToKnow, .readinessScore,
             .onboardingInputPlaceholder, .onboardingInputText, .loginEmailTitle, .loginEmailMessage, .loginEmailErrorMessage,
             .loginEmailCode, .loginEmailCodeMessage, .loginEmailCodeErrorMessage, .registrationEmailTitle,
             .registrationEmailMessage, .registrationEmailError, .registrationCodeTitle, .registrationCodePreCode,
             .registrationCodeError, .registrationCodeDisclaimerError, .registrationNamesTitle, .registrationNamesMandatory,
             .registrationAgeTitle, .locationPermissionTitle, .trackSelectionTitle, .askPermissionTitle,
             .weatherDescription, .weatherTitle, .weatherBody:
            string = NSAttributedString(string: text, letterSpacing: 0.0, font: self.font, lineSpacing: 0, textColor: self.color, alignment: .left)
        case .strategySubHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .questionHintLabel, .questionHintLabelDark, .questionHintLabelRed:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .center)
        case .articleAudioBar, .audioBar, .quotation, .quoteAuthor, .performanceSubtitle, .reference, .performanceSectionText,
             .sleepReference, .asterix, .bespokeText, .leaderText, .tbvSectionHeader, .syncedCalendarDescription:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .left)
        case .articleRelatedTitle, .articleRelatedTitleInStrategy, .articleNextTitle, .myQOTTitle, .whatsHotHeader, .myQOTPrepComment, .searchResult,
             .dailyBriefLevelTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, lineSpacing: 1, textColor: self.color, alignment: .left)
        case .articleBullet, .sectionHeader,
             .dailyBriefLevelContent,
             .weatherIntro:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .articleRelatedDetail, .articleRelatedDetailInStrategy, .sprintName, .sprintText, .solveQuestions, .solveFuture, .level5Question:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, textColor: self.color, alignment: .left)
        case .articleBody, .articlePostTitle, .articleSecondaryTitle, .articleSubTitle, .articleHeadline,
             .articleParagraph, .articleSector, .articlePostTitleNight, .searchContent, .tbvQuestionLight, .tbvQuestionMedium:
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
        case .settingsTitle, .settingsTitleFade, .myQOTProfileName, .accountDetail, .myQOTPrepCellTitle, .myQOTSectionHeader, .accountHeaderTitle,
             .tvbCounter, .tbvTrackerBody:
            string = NSAttributedString(string: text, font: self.font, textColor: self.color, alignment: .left)
        case .qotAlertTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.4, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .tbvHeader, .tbvVisionHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 3, textColor: self.color, alignment: .left)
        case .tbvVision, .tbvVisionBody:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, lineSpacing: 10, textColor: self.color, alignment: .left)
        case .qotAlertMessage, .syncedCalendarTableHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 6, textColor: self.color, alignment: .left)
        case .searchSuggestionHeader, .tbvButton, .tbvTrackerRating, .quotationSmall:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .tbvTrackerRatingDigits, .tbvTrackerRatingDigitsSelected:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .center, lineBreakMode: nil)
        case .myDataSectionHeaderTitle, .myDataSectionHeaderSubTitle, .myDataMonthYearTitle, .myDataChartValueLabels, .myDataExplanationCellSubtitle,
             .myDataHeatMapDetailCellDate, .myDataHeatMapCellDateText, .myDataHeatMapCellDateHighlighted, .myDataChartIRAverageLabel,
             .registrationCodeDescription, .registrationCodeDescriptionEmail, .registrationAgeDescription, .registrationAgeRestriction,
             .locationPermissionMessage, .trackSelectionMessage, .walkthroughMessage, .registrationCodeTermsAndPrivacy, .registrationCodeInfoActions,
             .dailyBriefSubtitle, .weatherHourlyLabelNow:
            string = NSAttributedString(string: text, letterSpacing: 0, font: self.font, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .myDataWeekdaysHighlighted(let centered), .myDataWeekdaysNotHighlighted(let centered):
            var alignment: NSTextAlignment = .left
            if centered {
                alignment = .center
            }
            string = NSAttributedString(string: text, letterSpacing: 0, font: self.font, textColor: self.color, alignment: alignment, lineBreakMode: nil)
        case .myDataParameterLegendText, .myDataHeatMapLegendText:
            string = NSAttributedString(string: text, letterSpacing: 0.17, font: self.font, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .myDataParameterSelectionTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .myDataParameterExplanationTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.29, font: self.font, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .myDataHeatMapDetailCellValue:
            string = NSAttributedString(string: text, letterSpacing: 0, font: self.font, textColor: self.color, alignment: .center, lineBreakMode: nil)
        case .createAccountMessage:
            string = NSAttributedString(string: text, letterSpacing: 0.71, font: self.font, lineSpacing: 6, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .registrationCodeLink(let url):
            string = NSAttributedString(string: text,
                                        attributes: [.font: self.font, .foregroundColor: self.color, .link: url])
        case .chatBotButton, .resultCounter, .resultCounterMax:
            string = NSAttributedString(string: text, font: self.font, textColor: self.color, alignment: .left)
        case .askPermissionMessage:
            string = NSAttributedString(string: text, letterSpacing: 0, font: self.font, lineSpacing: 7, textColor: self.color, alignment: .left, lineBreakMode: nil)
        default:
            string = NSAttributedString(string: "<NO THEME - \(self)>")
        }
        return string

    }

    func apply(_ text: String?, to view: UILabel?, lineSpacing: CGFloat? = nil,
        lineHeight: CGFloat? = nil) {
        guard let view = view else { return }

        view.alpha = 1.0
        let string = attributedString(text, lineSpacing: lineSpacing, lineHeight: lineHeight)
        if string.string.contains("<NO THEME") {
            view.backgroundColor = .clear
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

    func apply(_ text: String?, to textView: UITextView?, lineSpacing: CGFloat? = nil,
               lineHeight: CGFloat? = nil) {
        guard let view = textView else { return }

        view.alpha = 1.0
        let string = attributedString(text, lineSpacing: lineSpacing, lineHeight: lineHeight)
        if string.string.contains("<NO THEME") {
            view.backgroundColor = .clear
        } else {
            view.attributedText = string
            view.backgroundColor = .clear

            switch self {
            case .myDataSectionHeaderSubTitle:
                view.contentMode = .topLeft
            default:
                break
            }
        }
    }
}

private struct Fonts {
    static let fontRegular12 = UIFont.sfProtextRegular(ofSize: 12.0)
    static let fontRegular13 = UIFont.sfProtextRegular(ofSize: 13.0)
    static let fontRegular14 = UIFont.sfProtextRegular(ofSize: 14.0)
    static let fontRegular15 = UIFont.sfProtextRegular(ofSize: 15.0)
    static let fontRegular16 = UIFont.sfProtextRegular(ofSize: 16.0)
    static let fontRegular18 = UIFont.sfProtextRegular(ofSize: 18.0)
    static let fontRegular20 = UIFont.sfProtextRegular(ofSize: 20.0)
    static let fontRegular24 = UIFont.sfProtextRegular(ofSize: 24.0)

    static let fontMedium12 = UIFont.sfProtextMedium(ofSize: 12.0)
    static let fontMedium14 = UIFont.sfProtextMedium(ofSize: 14.0)
    static let fontMedium16 = UIFont.sfProtextMedium(ofSize: 16.0)
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

    static let fontSemiBold12 = UIFont.sfProtextSemibold(ofSize: 12.0)
    static let fontSemiBold14 = UIFont.sfProtextSemibold(ofSize: 14.0)
    static let fontSemiBold16 = UIFont.sfProtextSemibold(ofSize: 16.0)

    static let fontDisplayLight24 = UIFont.sfProDisplayLight(ofSize: 24)
    static let fontDisplayRegular20 = UIFont.sfProDisplayRegular(ofSize: 20.0)
    static let fontDisplayRegular16 = UIFont.sfProDisplayRegular(ofSize: 16.0)
    static let fontDisplayThin30 = UIFont.sfProDisplayThin(ofSize: 30.0)
    static let fontDisplayThin34 = UIFont.sfProDisplayThin(ofSize: 34.0)
    static let fontDisplayThin42 = UIFont.sfProDisplayThin(ofSize: 42.0)
    static let fontDisplayUltralight64 = UIFont.sfProDisplayUltralight(ofSize: 64.0)
    static let fontDisplayUltralight120 = UIFont.sfProDisplayUltralight(ofSize: 120.0)
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

    static var accent40: UIColor {
        return UIColor.accent.withAlphaComponent(0.4)
    }

    static var accent60: UIColor {
        return UIColor.accent.withAlphaComponent(0.6)
    }

    static var accent70: UIColor {
        return UIColor.accent.withAlphaComponent(0.7)
    }

    static var carbonDark: UIColor {
        return UIColor(red: 8/255, green: 8/255, blue: 7/255, alpha: 1)
    }

    static var carbonDark40: UIColor {
         return UIColor.carbonDark.withAlphaComponent(0.4)
    }

    static var sand: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 1)
    }

    static var carbonDark80: UIColor {
        return UIColor.carbonDark.withAlphaComponent(0.8)
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

    static var redOrange70: UIColor {
        return UIColor.redOrange.withAlphaComponent(0.7)
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

    static var sleepQuality: UIColor {
        return UIColor.sleepQuality
    }

    static var sleepQuantity: UIColor {
        return UIColor.sleepQuantity
    }

    static var tenDayLoad: UIColor {
        return UIColor.tenDayLoad
    }

    static var fiveDayRecovery: UIColor {
        return UIColor.fiveDayRecovery
    }

    static var fiveDayLoad: UIColor {
        return UIColor.fiveDayLoad
    }

    static var fiveDayImpactReadiness: UIColor {
        return UIColor.fiveDayImpactReadiness
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

    static var white40: UIColor {
        return UIColor.white.withAlphaComponent(0.4)
    }

    static var heatMapDarkBlue: UIColor {
        return UIColor.heatMapDarkBlue
    }

    static var heatMapBrightRed: UIColor {
        return UIColor.heatMapBrightRed
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

    static func parameterColor(for parameter: MyDataParameter) -> UIColor {
        switch parameter {
        case .SQL:
            return Palette.sleepQuality
        case .SQN:
            return Palette.sleepQuantity
        case .tenDL:
            return Palette.tenDayLoad
        case .fiveDRR:
            return Palette.fiveDayRecovery
        case .fiveDRL:
            return Palette.fiveDayLoad
        case .fiveDIR:
            return Palette.fiveDayImpactReadiness
        case .IR:
            return Palette.sand
        }
    }
}
