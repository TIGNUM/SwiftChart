//
//  SubsriptionReminderWorker.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SubsriptionReminderWorker {

    // MARK: - Properties

    private let isExpired: Bool

    // MARK: - Init

    init(isExpired: Bool) {
        self.isExpired = isExpired
    }

    var expired: Bool {
        return isExpired
    }

    var title: NSAttributedString? {
        return SubsriptionReminderModel.Items.title.attributedText()
    }

    var subTitle: NSAttributedString? {
        if isExpired == true {
            return SubsriptionReminderModel.Items.subtitleExpired.attributedText()
        }
        return SubsriptionReminderModel.Items.subtitle.attributedText()
    }

    var benefitsTitleFirst: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsTitleFirst.attributedText()
    }

    var benefitsSubtitleFirst: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsSubtitleFirst.attributedText()
    }

    var benefitsTitleSecond: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsTitleSecond.attributedText()
    }

    var benefitsSubtitleSecond: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsSubtitleSecond.attributedText()
    }

    var benefitsTitleThird: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsTitleThird.attributedText()
    }

    var benefitsSubtitleThird: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsSubtitleThird.attributedText()
    }

    var benefitsTitleFourth: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsTitleFourth.attributedText()
    }

    var benefitsSubtitleFourth: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsSubtitleFourth.attributedText()
    }
}
