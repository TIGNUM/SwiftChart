//
//  SubsriptionReminderModel.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct SubsriptionReminderModel {

    enum Items: String, CaseIterable {
        case title = "subscription_reminder_title"
        case subtitle = "subscription_reminder_subtitle"
        case subtitleExpired = "subscription_reminder_subtitle_expired"
        case benefitsTitleFirst = "subscription_reminder_benefit_title_01"
        case benefitsSubtitleFirst = "subscription_reminder_benefit_subtitle_01"
        case benefitsTitleSecond = "subscription_reminder_benefit_title_02"
        case benefitsSubtitleSecond = "subscription_reminder_benefit_subtitle_02"
        case benefitsTitleThird = "subscription_reminder_benefit_title_03"
        case benefitsSubtitleThird = "subscription_reminder_benefit_subtitle_03"
        case benefitsTitleFourth = "subscription_reminder_benefit_title_04"
        case benefitsSubtitleFourth = "subscription_reminder_benefit_subtitle_04"

        private var predicate: NSPredicate {
            return NSPredicate(tag: rawValue)
        }

        private var font: UIFont {
            switch self {
            case .title: return .apercuRegular(ofSize: 37)
            case .subtitle,
                 .subtitleExpired: return .apercuRegular(ofSize: 18)
            case .benefitsTitleFirst,
                 .benefitsTitleSecond,
                 .benefitsTitleThird,
                 .benefitsTitleFourth: return .apercuMedium(ofSize: 15)
            case .benefitsSubtitleFirst,
                 .benefitsSubtitleSecond,
                 .benefitsSubtitleThird,
                 .benefitsSubtitleFourth: return .apercuRegular(ofSize: 15)
            }
        }

        private var textColor: UIColor {
            switch self {
            case .title: return .white
            case .subtitle,
                 .subtitleExpired: return .white60
            case .benefitsTitleFirst,
                 .benefitsTitleSecond,
                 .benefitsTitleThird,
                 .benefitsTitleFourth: return .white
            case .benefitsSubtitleFirst,
                 .benefitsSubtitleSecond,
                 .benefitsSubtitleThird,
                 .benefitsSubtitleFourth: return .white50
            }
        }

        private var lineSpacing: CGFloat {
            switch self {
            case .title: return 0
            case .subtitle,
                 .subtitleExpired: return 12
            case .benefitsTitleFirst,
                 .benefitsTitleSecond,
                 .benefitsTitleThird,
                 .benefitsTitleFourth: return 0
            case .benefitsSubtitleFirst,
                 .benefitsSubtitleSecond,
                 .benefitsSubtitleThird,
                 .benefitsSubtitleFourth: return 8
            }
        }

        func attributedText(contentSerice: ContentService) -> NSAttributedString? {
            guard let text = contentSerice.contentItem(for: self.predicate)?.valueText else { return nil }
            return NSMutableAttributedString(string: text,
                                             letterSpacing: 0,
                                             font: font,
                                             lineSpacing: lineSpacing,
                                             textColor: textColor,
                                             alignment: .left,
                                             lineBreakMode: .byWordWrapping)
        }
    }
}
