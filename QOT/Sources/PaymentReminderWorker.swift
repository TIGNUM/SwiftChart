//
//  PaymentReminderWorker.swift
//  
//
//  Created by Anais Plancoulaine on 17.06.19.
//

import UIKit
import qot_dal

final class PaymentReminderWorker {

    // MARK: - Properties

    private let isExpired: Bool

    // MARK: - Init

    init(isExpired: Bool) {
        self.isExpired = isExpired
    }

    var expired: Bool {
        return isExpired
    }

    // MARK: - Functions

    func paymentSections() -> PaymentModel {
        let headerTitle = ScreenTitleService.main.paymentHeaderTitle()
        let headerSubtitle = ScreenTitleService.main.paymentHeaderSubtitle()
        let sections = isExpired ? PaymentSection.expiredSectionValues : PaymentSection.notExpiredSectionValues
        let paymentItems =  sections.map {
            return PaymentModel.Item(paymentSection: $0,
                                   title: ScreenTitleService.main.paymentSectionTitles(for: $0),
                                   subtitle: ScreenTitleService.main.paymentSectionSubtitles(for: $0)) }
        return PaymentModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, paymentItems: paymentItems)
    }
}
