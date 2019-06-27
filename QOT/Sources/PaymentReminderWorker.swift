//
//  PaymentReminderWorker.swift
//  
//
//  Created by Anais Plancoulaine on 17.06.19.
//

import UIKit

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
        let headerTitle = services.contentService.paymentHeaderTitle()
        let headerSubtitle = services.contentService.paymentHeaderSubtitle()
        let paymentItems =  PaymentSection.allCases.map {
            return PaymentModel.Item(paymentSections: $0,
                                   title: services.contentService.paymentSectionTitles(for: $0),
                                   subtitle: services.contentService.paymentSectionSubtitles(for: $0)) }
        return PaymentModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, paymentItems: paymentItems)
    }
}
