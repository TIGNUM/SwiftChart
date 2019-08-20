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

    // MARK: - Functions

    func paymentSections() -> PaymentModel {
        let headerTitle = ScreenTitleService.main.paymentHeaderTitle()
        let headerSubtitle = ScreenTitleService.main.paymentHeaderSubtitle()
        let paymentItems =  PaymentSection.allCases.map {
            return PaymentModel.Item(paymentSections: $0,
                                   title: ScreenTitleService.main.paymentSectionTitles(for: $0),
                                   subtitle: ScreenTitleService.main.paymentSectionSubtitles(for: $0)) }
        return PaymentModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, paymentItems: paymentItems)
    }
}
