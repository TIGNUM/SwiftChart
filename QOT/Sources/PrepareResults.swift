//
//  PrepareResultsModel.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum ReminderType {
    case iCal
    case reminder
}

enum PrepareResultsType {
    case contentItem(format: ContentFormat, title: String)
    case eventItem(title: String, date: Date, type: String)
    case strategy(title: String, durationString: String, readMoreID: Int)
    case reminder(title: String, subbtitle: String, active: Bool, type: ReminderType)
    case intentionContentItem(format: ContentFormat, title: String?, key: Prepare.Key)
    case intentionItem(title: String)
    case benefitContentItem(format: ContentFormat, title: String?, benefits: String?, questionID: Int)
    case benefitItem(benefits: String?)
}

extension ContentFormat {
    var isTitle: Bool {
        switch self {
        case .title: return true
        default: return false
        }
    }

    var isHeader: Bool {
        switch self {
        case .header1, .header2: return true
        default: return false
        }
    }

    var rowHeight: CGFloat {
        switch self {
        case .header1: return 68
        case .header2: return 20
        case .list: return 80
        case .title: return 64
        case .listitem: return 48
        default: return 96
        }
    }

    var hasListMark: Bool {
        switch self {
        case .listitem: return true
        default: return false
        }
    }

    func hasBottomSeperator(_ type: QDMUserPreparation.Level) -> Bool {
        switch self {
        case .title: return type == .LEVEL_CRITICAL ? false : true
        default: return false
        }
    }

    var hasHeaderMark: Bool {
        switch self {
        case .header1: return true
        default: return false
        }
    }

    func hasEditImage(_ type: QDMUserPreparation.Level) -> Bool {
        switch self {
        case .title: return type == .LEVEL_CRITICAL
        default: return false
        }
    }

    func attributedText(title: String?) -> NSAttributedString? {
        guard let title = title else { return nil }
        switch self {
        case .header1: return ThemeText.resultHeader1.attributedString(title)
        case .header2,
             .listitem: return ThemeText.resultHeader2.attributedString(title)
        case .list: return ThemeText.resultList.attributedString("\n\n" + title)
        case .title: return ThemeText.resultTitle.attributedString(title)
        default: return nil
        }
    }

    func attributed(_ text: String, _ font: UIFont, _ color: UIColor) -> NSAttributedString? {
        return NSAttributedString(string: text, font: font, textColor: color, alignment: .left)
    }
}

struct PrepareResult {
    struct Daily: Hashable {
        static let HEADER = 0
        static let EVENT_LIST = 1
        static let EVENT_ITEMS = 2
        static let INTENTION_LIST = 3
        static let INTENTION_TITLES = 4
        static let STRATEGY_LIST = 5
        static let STRATEGY_ITEMS = 6
        static let REMINDER_LIST = 7
        static let REMINDER_ITEMS = 8
    }

    struct Critical: Hashable {
        static let HEADER = 0
        static let EVENT_LIST = 1
        static let EVENT_ITEMS = 2
        static let INTENTION_LIST = 3
        static let PERCEIVED_TITLE = 4
        static let PERCEIVED_ITEMS = 5
        static let KNOW_TITLE = 6
        static let KNOW_ITEMS = 7
        static let FEEL_TITLE = 8
        static let FEEL_ITEMS = 9
        static let BENEFIT_LIST = 10
        static let BENEFIT_TITLE = 11
        static let BENEFITS = 12
        static let STRATEGY_LIST = 13
        static let STRATEGY_ITEMS = 14
        static let REMINDER_LIST = 15
        static let REMINDER_ITEMS = 16
    }

    enum Key: String {
        case perceived = "prepare_peak_prep_relationship_intentions_preceived"
        case know = "prepare_peak_prep_relationship_intentions_know"
        case feel = "prepare_peak_prep_relationship_intentions_feel"
        case benefits = "prepare_peak_prep_benefits_input"
        case benefitsTitle = "prepare_check_list_critical_benefits_title"
        case eventType = "prepare-event-type-selection-critical"

        var questionID: Int {
            switch self {
            case .perceived: return 100326
            case .know: return 100330
            case .feel: return 100331
            case .benefits: return 100332
            case .benefitsTitle: return 0
            case .eventType: return 100339
            }
        }

        var tag: String {
            switch self {
            case .perceived: return "PERCEIVED"
            case .know: return "KNOW"
            case .feel: return "FEEL"
            case .benefits: return "BENEFITS"
            case .benefitsTitle,
                 .eventType: return ""
            }
        }
    }
}

extension QDMUserPreparation.Level {
    var contentID: Int {
        switch self {
        case .LEVEL_ON_THE_GO: return 101256
        case .LEVEL_DAILY: return 101258
        case .LEVEL_CRITICAL: return 101260
        default: return 0
        }
    }

    var key: String? {
        switch self {
        case .LEVEL_ON_THE_GO: return nil
        case .LEVEL_DAILY: return Prepare.AnswerKey.EventTypeSelectionDaily
        case .LEVEL_CRITICAL: return Prepare.AnswerKey.EventTypeSelectionCritical
        default: return nil
        }
    }
}

extension QDMUserPreparation {
    typealias AnswerFilter = String
}

extension QDMUserPreparation.AnswerFilter {
    static let perceived = "prepare_peak_prep_relationship_intentions_preceived"
    static let know = "prepare_peak_prep_relationship_intentions_know"
    static let feel = "prepare_peak_prep_relationship_intentions_feel"
    static let benefits = "prepare_peak_prep_benefits_input"
    static let benefitsTitle = "prepare_check_list_critical_benefits_title"
    static let eventType = "prepare-event-type-selection-critical"
}
