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
}
