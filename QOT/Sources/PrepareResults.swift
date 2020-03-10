//
//  PrepareResultsModel.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
//FIXME: https://tignum.atlassian.net/browse/QOT-2688
// We need to rebuild the complete prepare results structure
enum PrepareResultsType {
    case contentItem(format: ContentFormat, title: String)
    case eventItem(title: String, date: Date, type: String)
    case strategy(title: String, durationString: String, readMoreID: Int)
    case intentionContentItem(format: ContentFormat, title: String?, key: Prepare.Key)
    case intentionItem(title: String)
    case benefitContentItem(format: ContentFormat, title: String?, benefits: String?, questionID: Int)
    case benefitItem(benefits: String?)
    case addToCalendar(title: String, subtitle: String)
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

    func hasEditImage(_ type: QDMUserPreparation.Level, title: String?) -> Bool {
        switch self {
        case .title: return type == .LEVEL_CRITICAL
        case .list: return type != .LEVEL_ON_THE_GO && title == "SUGGESTED STRATEGIES"
        default: return false
        }
    }

    func attributedText(title: String?) -> NSAttributedString? {
        guard let title = title else { return nil }
        switch self {
        case .header1: return ThemeText.resultHeader1.attributedString(title)
        case .header2,
             .listitem: return ThemeText.resultHeader2.attributedString(title)
        case .list: return ThemeText.resultList.attributedString("\n" + title + "\n")
        case .title: return ThemeText.resultTitle.attributedString(title)
        default: return nil
        }
    }
}

struct PrepareResult {
    struct Daily: Hashable {
        static let HEADER = 0
        static let ADD_TO_CALENDAR = 1
        static let INTENTION_LIST = 2
        static let INTENTION_TITLES = 3
        static let STRATEGY_LIST = 4
        static let STRATEGY_ITEMS = 5
    }

    struct Critical: Hashable {
        static let HEADER = 0
        static let ADD_TO_CALENDAR = 1
        static let INTENTION_LIST = 2
        static let PERCEIVED_TITLE = 3
        static let PERCEIVED_ITEMS = 4
        static let KNOW_TITLE = 5
        static let KNOW_ITEMS = 6
        static let FEEL_TITLE = 7
        static let FEEL_ITEMS = 8
        static let BENEFIT_LIST = 8
        static let BENEFIT_TITLE = 10
        static let BENEFITS = 11
        static let STRATEGY_LIST = 12
        static let STRATEGY_ITEMS = 13
    }
}
