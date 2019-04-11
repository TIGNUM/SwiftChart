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

    private let services: Services
    private let isExpired: Bool

    // MARK: - Init

    init(services: Services, isExpired: Bool) {
        self.services = services
        self.isExpired = isExpired
    }

    var expired: Bool {
        return isExpired
    }

    var title: NSAttributedString? {
       return SubsriptionReminderModel.Items.title.attributedText(contentSerice: services.contentService)
    }

    var subTitle: NSAttributedString? {
        if isExpired == true {
            return SubsriptionReminderModel.Items.subtitleExpired.attributedText(contentSerice: services.contentService)
        }
        return SubsriptionReminderModel.Items.subtitle.attributedText(contentSerice: services.contentService)
    }

    var benefitsTitleFirst: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsTitleFirst.attributedText(contentSerice: services.contentService)
    }

    var benefitsSubtitleFirst: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsSubtitleFirst.attributedText(contentSerice: services.contentService)
    }

    var benefitsTitleSecond: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsTitleSecond.attributedText(contentSerice: services.contentService)
    }

    var benefitsSubtitleSecond: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsSubtitleSecond.attributedText(contentSerice: services.contentService)
    }

    var benefitsTitleThird: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsTitleThird.attributedText(contentSerice: services.contentService)
    }

    var benefitsSubtitleThird: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsSubtitleThird.attributedText(contentSerice: services.contentService)
    }

    var benefitsTitleFourth: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsTitleFourth.attributedText(contentSerice: services.contentService)
    }

    var benefitsSubtitleFourth: NSAttributedString? {
        return SubsriptionReminderModel.Items.benefitsSubtitleFourth.attributedText(contentSerice: services.contentService)
    }
}
