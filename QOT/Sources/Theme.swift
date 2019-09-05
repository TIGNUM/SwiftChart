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
        case .onboarding:
            return Palette.carbon
        case .article:
            return Palette.light(Palette.sand, or: Palette.carbon)
        case .articleBackground(let mode):
            return Palette.light(Palette.sand, or: Palette.carbon, forcedColorMode: mode)
        case .articleSeparator(let mode):
            return Palette.light(Palette.carbon10, or: Palette.sand10, forcedColorMode: mode)
        case .articleAudioBar:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .audioBar, .headerLine, .qSearch:
            return Palette.sand
        case .fade:
            return Palette.light(Palette.sand10, or: Palette.carbon10)
        case .separator:
            return Palette.light(Palette.carbon10, or: Palette.sand10)
        case .accentBackground, .prepsSegmentSelected, .articleMarkRead, .articleMarkUnread:
            return Palette.accent30
        case .qotAlert:
            return Palette.carbonDark80
        case .imageOverlap:
            return Palette.carbon60
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

enum ThemeButton {
    case accent40

    func apply(_ button: UIButton, selected: Bool = false, selectedImage: UIImage? = nil, unSelectedImage: UIImage? = nil) {
        var color: UIColor?
        switch self {
        case .accent40:
            color = Palette.accent40
        }

        if let color = color {
            button.layer.borderWidth = selected ? 0 : 1
            button.layer.borderColor = selected ? UIColor.clear.cgColor : color.cgColor
            button.corner(radius: button.frame.size.height / 2)

        }
        button.backgroundColor = selected ? color : .clear
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
            view.backgroundColor = .clear
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
                searchField.backgroundColor = Palette.carbon
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
    case myQOTProfileName
    case myQOTPrepCellTitle
    case myQOTPrepTitle
    case myQOTPrepComment
    case myQOTSectionHeader
    case accountHeader
    case accountDetail
    case accountHeaderTitle
    case quotation
    case dailyBriefTitle
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
    case dailyBriefDailyCheckInSights
    case dailyBriefDailyCheckInClosedBucket

    private var font: UIFont {
        switch self {
        case .registrationCodeDisclaimerError:
            return Fonts.fontRegular12
        case .asterix:
            return Fonts.fontRegular13
        case .navigationBarHeader, .sectionHeader, .categoryHeader, .fromCoachTitle, .myQOTSectionHeader, .tbvTrackerHeader, .myDataSectionHeaderTitle, .dailyBriefDailyCheckInClosedBucket:
            return Fonts.fontRegular20
        case .categorySubHeader, .searchTopic, .solveFuture, .level5Question, .performanceSectionText, .goodToKnow, .bespokeText, .leaderText, .tbvVision, .tbvVisionBody, .myDataMonthYearTitle, .myDataExplanationCellSubtitle, .myDataHeatMapDetailCellDate, .registrationCodeDescription, .registrationCodePreCode, .registrationAgeDescription, .locationPermissionMessage, .accountDetail, .dailyBriefLevelContent, .dailyBriefDailyCheckInSights:
            return Fonts.fontRegular16
        case .leaderVideoTitle, .searchExploreTopic, .searchBar,
             .performanceSubtitle, .quoteAuthor, .sleepReference, .reference, .searchResult, .searchSuggestion, .tbvTrackerBody, .loginEmailMessage,
             .loginEmailErrorMessage, .loginEmailCode, .loginEmailCodeMessage, .loginEmailCodeErrorMessage,
             .tbvTrackerRatingDigits, .myDataSectionHeaderSubTitle, .registrationEmailMessage, .registrationEmailError,
             .registrationCodeError, .registrationCodeTermsAndPrivacy, .registrationCodeInfoActions, .registrationNamesMandatory,
             .registrationAgeRestriction, .trackSelectionMessage:
            return Fonts.fontRegular14
        case .author, .datestamp, .articleAuthor, .linkMenuComment, .linkMenuCommentRed, .articleRelatedDetail, .durationString,
             .articleTagTitle, .settingsTitle, .settingsTitleFade, .articleMarkRead, .myDataChartValueLabels:
            return Fonts.fontMedium12
        case .linkMenuItem, .myQOTBoxTitle, .myQOTPrepTitle:
            return Fonts.fontLight20
        case .readinessScore:
            return Fonts.fontDisplayUltralight64
        case .audioBar, .articleAudioBar, .segmentHeading, .tbvButton, .myDataSwitchButtons, .myDataWeekdaysHighlighted, .registrationCodeLink:
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
        case .sprintName, .performanceBucketTitle, .myDataHeatMapCellDateText, .tbvQuestionMedium:
            return Fonts.fontMedium16
        case .articleCategoryNotScaled:
            return Fonts.fontMedium12
        case .articleTitle:
            switch textScale {
            case .scale: return Fonts.fontLight40
            case .scaleNot: return Fonts.fontLight34
            }
        case .articleTitleNotScaled, .tbvHeader, .tbvVisionHeader:
            return Fonts.fontLight34
        case .articleBullet,
             .dailyBriefLevelContent:
            switch textScale {
            case .scale: return Fonts.fontLight24
            case .scaleNot: return Fonts.fontLight16
            }
        case .articleBody:
            switch textScale {
            case .scale: return Fonts.fontRegular24
            case .scaleNot: return Fonts.fontRegular16
            }
        case .articleRelatedTitle, .myQOTTitle, .whatsHotHeader, .sprintText, .sprintTitle, .solveQuestions, .impactBucket,
             .chatButton, .chatButtonEnabled, .articleMediaDescription, .articleHeadlineSmall, .articleHeadlineSmallRed,
             .articleHeadlineSmallFade, .articleHeadlineSmallLight, .myQOTPrepCellTitle, .myQOTPrepComment,
             .tbvBody, .tvbTimeSinceTitle, .tbvTrackerAnswer, .accountHeader, .accountHeaderTitle,
             .dailyBriefLevelTitle, .strategySubHeader, .tbvQuestionLight:
            return Fonts.fontLight16
        case .articleNextTitle, .performanceSections, .searchSuggestionHeader, .tbvSectionHeader,
             .tbvTrackerRating, .tbvTrackerRatingDigitsSelected, .performanceStaticTitle:
            return Fonts.fontMedium14
        case .strategyHeader:
            return Fonts.fontDisplayRegular20
        case .quotation:
            return Fonts.fontDisplayThin34
        case .dailyBriefTitle, .loginEmailTitle, .registrationEmailTitle, .registrationCodeTitle, .registrationNamesTitle,
             .registrationAgeTitle, .locationPermissionTitle, .trackSelectionTitle:
            return Fonts.fontDisplayRegular20
        case .tbvStatement:
            return Fonts.fontDisplayLight24
        case .articlePostTitle, .articlePostTitleNight:
            return Fonts.fontLight36
        case .articleSecondaryTitle:
            return Fonts.fontLight32
        case .articleSubTitle, .myQOTProfileName:
            return Fonts.fontLight24
        case .articleHeadline, .learnPDF:
            return Fonts.fontLight20
        case .articleNavigationTitle, .guideNavigationTitle, .calendarNoAccess, .myDataWeekdaysNotHighlighted:
            return Fonts.fontLight14
        case .articleTag, .articleTagSelected, .articleTagNight, .version, .placeholder,
             .articleParagraph, .learnVideo, .learnImage, .articleSector, .searchContent:
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
        case .myDataChartIRAverageLabel:
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
             .articleRelatedTitle, .sectionHeader, .categoryHeader, .categorySubHeader, .performanceTitle, .bespokeTitle,
             .chatButtonEnabled, .settingsTitle, .strategyHeader, .myQOTBoxTitle, .sprintName, .sprintTitle, .solveQuestions,
             .tbvStatement, .level5Question, .leaderText, .leaderVideoTitle, .myQOTProfileName, .myQOTTitle,
             .myQOTPrepCellTitle, .myQOTSectionHeader, .myQOTPrepTitle, .searchResult, .onboardingInputText,
             .tbvVisionHeader, .tbvVisionBody, .tvbTimeSinceTitle, .tvbCounter, .tbvTrackerHeader, .tbvTrackerRating,
             .tbvTrackerRatingDigitsSelected, .loginEmailTitle, .myDataSectionHeaderTitle, .myDataMonthYearTitle, .myDataWeekdaysHighlighted, .myDataHeatMapDetailCellValue, .myDataHeatMapCellDateHighlighted, .registrationEmailTitle, .registrationCodeTitle,
             .dailyBriefLevelTitle, .searchSuggestion, .accountHeader,
             .registrationNamesTitle, .registrationAgeTitle, .locationPermissionTitle, .trackSelectionTitle, .walkthroughMessage,.dailyBriefLevelContent, .dailyBriefDailyCheckInClosedBucket,
             .tbvQuestionLight, .tbvQuestionMedium:
            return Palette.sand
        case .quoteAuthor, .chatButton, .myDataChartValueLabels, .myDataHeatMapLegendText:
            return Palette.sand60
        case .datestamp, .performanceStaticTitle, .durationString, .solveFuture, .searchExploreTopic, .searchBar, .reference,
             .settingsTitleFade, .searchContent, .searchSuggestionHeader, .tbvVision, .tbvSectionHeader, .tbvTrackerRatingDigits, .myDataChartIRAverageLabel, .registrationNamesMandatory, .accountDetail:
            return Palette.sand40
        case .performanceSubtitle:
            return Palette.carbonDark40
        case .linkMenuItem, .audioBar, .performanceBucketTitle, .articleToolBarTint, .strategyTitle, .sleepReference, .tbvButton, .myDataSwitchButtons, .registrationCodeLink, .accountHeaderTitle:
            return Palette.accent
        case .performanceSections:
            return Palette.carbon40
        case .fromCoachTitle:
            return Palette.carbon
        case .linkMenuComment, .strategySubHeader, .sprintText, .bespokeText, .goodToKnow, .readinessScore,
             .myQOTPrepComment, .tbvHeader, .tbvBody, .tbvTrackerBody, .tbvTrackerAnswer, .loginEmailMessage, .loginEmailCode, .loginEmailCodeMessage, .myDataSectionHeaderSubTitle, .myDataWeekdaysNotHighlighted, .myDataHeatMapCellDateText, .myDataExplanationCellSubtitle, .myDataHeatMapDetailCellDate, .onboardingInputPlaceholder, .createAccountMessage,
             .registrationEmailMessage, .registrationCodeDescription, .registrationCodeDescriptionEmail, .trackSelectionMessage,
             .registrationCodePreCode, .registrationCodeTermsAndPrivacy, .registrationCodeInfoActions, .registrationAgeDescription,
             .registrationAgeRestriction, .locationPermissionMessage, .author, .dailyBriefDailyCheckInSights:
            return Palette.sand70
        case .performanceSectionText:
            return Palette.carbon70
        case .linkMenuCommentRed, .loginEmailErrorMessage, .loginEmailCodeErrorMessage, .registrationEmailError,
             .registrationCodeDisclaimerError:
            return Palette.redOrange
        case .articleAudioBar, .articleMarkRead:
            return Palette.light(Palette.sand60, or: Palette.carbon60)
        case .articleCategory, .articleCategoryNotScaled:
             return Palette.light(Palette.carbon30, or: Palette.sand30)
        case .articleTitle, .articleTitleNotScaled, .articleBody:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .articleDatestamp:
            return Palette.light(Palette.carbon30, or: Palette.sand30)
        case .articleNextTitle:
            return Palette.light(Palette.carbon40, or: Palette.sand40)
        case .whatsHotHeader(let mode):
            return Palette.light(Palette.carbon, or: Palette.sand, forcedColorMode: mode)
        case .articleAuthor(let mode):
            return Palette.light(Palette.carbon60, or: Palette.sand60, forcedColorMode: mode)
        case .articlePostTitle, .articleSecondaryTitle, .articleSubTitle, .articleHeadline, .articleHeadlineSmall,
             .articleNavigationTitle, .articleTagTitle, .articleParagraph, .article,
             .articleQuestion, .articleSub, .articleNum, .articleSector:
            return Palette.light(Palette.carbon, or: Palette.sand)
        case .articleQuote, .articleMediaDescription:
            return Palette.light(Palette.carbon60, or: Palette.sand60)
        case .articleBullet,
             .dailyBriefLevelContent:
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
        case .myDataParameterLegendText(let parameter), .myDataParameterSelectionTitle(let parameter), .myDataParameterExplanationTitle(let parameter):
            return Palette.parameterColor(for: parameter)
        }
    }

    func attributedString(_ input: String?, lineSpacing: CGFloat? = nil, lineHeight: CGFloat? = nil) -> NSAttributedString {
        let text = input != nil ? input! : ""
        let string: NSAttributedString

        switch self {
        case .navigationBarHeader, .articleCategory, .articleCategoryNotScaled, .articleAuthor, .articleDatestamp,
             .author, .articleMarkRead, .myQOTBoxTitle, .durationString, .tbvStatement, .dailyBriefTitle, .strategyTitle,
//             todo check with domnic
             .myQOTPrepTitle, .tbvTrackerHeader, .dailyBriefDailyCheckInSights:
            string = NSAttributedString(string: text, letterSpacing: 0.4, font: self.font, textColor: self.color, alignment: .left)
        case .articleTitle, .articleTitleNotScaled, .performanceSections, .bespokeTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 4, textColor: self.color, alignment: .left)
        case .strategyHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.3, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .performanceStaticTitle, .fromCoachTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.3, font: self.font, textColor: self.color, alignment: .left)
        case .sprintTitle, .leaderVideoTitle, .searchSuggestion, .tbvBody, .tvbTimeSinceTitle, .tbvTrackerAnswer:
             string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, textColor: self.color, alignment: .left)
        case .datestamp, .linkMenuComment, .linkMenuItem, .linkMenuCommentRed, .performanceBucketTitle, .goodToKnow, .readinessScore,
             .onboardingInputPlaceholder, .onboardingInputText, .loginEmailTitle, .loginEmailMessage, .loginEmailErrorMessage,
             .loginEmailCode, .loginEmailCodeMessage, .loginEmailCodeErrorMessage, .registrationEmailTitle,
             .registrationEmailMessage, .registrationEmailError, .registrationCodeTitle, .registrationCodePreCode,
             .registrationCodeError, .registrationCodeDisclaimerError, .registrationNamesTitle, .registrationNamesMandatory,
             .registrationAgeTitle, .locationPermissionTitle, .trackSelectionTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.0, font: self.font, lineSpacing: 0, textColor: self.color, alignment: .left)
        case .strategySubHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .articleAudioBar, .audioBar, .quotation, .quoteAuthor, .performanceSubtitle, .reference, .performanceSectionText, .sleepReference, .asterix, .bespokeText, .leaderText, .tbvSectionHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .left)
        case .articleRelatedTitle, .articleNextTitle, .myQOTTitle, .whatsHotHeader, .myQOTPrepComment, .searchResult,
             .dailyBriefLevelTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, lineSpacing: 1, textColor: self.color, alignment: .left)
        case .articleBullet, .sectionHeader,
             .dailyBriefLevelContent:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left)
        case .articleRelatedDetail, .sprintName, .sprintText, .solveQuestions, .solveFuture, .level5Question:
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
        case .settingsTitle, .settingsTitleFade, .myQOTProfileName, .accountDetail, .accountHeader, .myQOTPrepCellTitle, .myQOTSectionHeader, .accountHeaderTitle,
             .tvbCounter, .tbvTrackerBody:
            string = NSAttributedString(string: text, font: self.font, textColor: self.color, alignment: .left)
        case .qotAlertTitle:
            string = NSAttributedString(string: text, letterSpacing: 0.4, font: self.font, lineSpacing: 8, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .tbvHeader, .tbvVisionHeader:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 3, textColor: self.color, alignment: .left)
        case .tbvVision, .tbvVisionBody:
            string = NSAttributedString(string: text, letterSpacing: 0.5, font: self.font, lineSpacing: 10, textColor: self.color, alignment: .left)
        case .qotAlertMessage:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, lineSpacing: 6, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .searchSuggestionHeader, .tbvButton, .tbvTrackerRating:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .left, lineBreakMode: nil)
        case .tbvTrackerRatingDigits, .tbvTrackerRatingDigitsSelected:
            string = NSAttributedString(string: text, letterSpacing: 0.2, font: self.font, textColor: self.color, alignment: .center, lineBreakMode: nil)
        case .myDataSectionHeaderTitle, .myDataSectionHeaderSubTitle, .myDataMonthYearTitle, .myDataChartValueLabels, .myDataExplanationCellSubtitle, .myDataHeatMapDetailCellDate, .myDataHeatMapCellDateText, .myDataHeatMapCellDateHighlighted, .myDataChartIRAverageLabel, .registrationCodeDescription, .registrationCodeDescriptionEmail, .registrationAgeDescription, .registrationAgeRestriction, .locationPermissionMessage, .trackSelectionMessage, .walkthroughMessage, .registrationCodeTermsAndPrivacy, .registrationCodeInfoActions:
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
        default:
            string = NSAttributedString(string: "<NO THEME - \(self)>")
        }
        return string
    }

    func apply(_ text: String?, to view: UILabel?, lineSpacing: CGFloat? = nil,
        lineHeight: CGFloat? = nil) {
        guard let view = view else { return }

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
