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
        let headerTitle = isExpired ? AppTextService.get(AppTextKey.payment_view_header_title_expired) : AppTextService.get(AppTextKey.payment_view_header_title)
        let headerSubtitle = isExpired ? AppTextService.get(AppTextKey.payment_view_header_subtitle_expired) : AppTextService.get(AppTextKey.payment_view_header_subtitle)
        let sections = isExpired ? PaymentSection.expiredSectionValues : PaymentSection.notExpiredSectionValues
        let paymentItems =  sections.map {
            return PaymentModel.Item(paymentSection: $0,
                                   title: paymentSectionTitles(for: $0),
                                   subtitle: paymentSectionSubtitles(for: $0)) }
        return PaymentModel(headerTitle: headerTitle, headerSubtitle: headerSubtitle, paymentItems: paymentItems)
    }

    func paymentSectionTitles(for paymentItem: PaymentSection) -> String? {
        switch paymentItem {
        case .prepared:
            return AppTextService.get(AppTextKey.payment_view_prepared_title)
        case .impact:
            return AppTextService.get(AppTextKey.payment_view_impact_title)
        case .grow:
            return AppTextService.get(AppTextKey.payment_view_grow_title)
        case .data:
            return AppTextService.get(AppTextKey.payment_view_header_title)
        case .switchAccount:
            return AppTextService.get(AppTextKey.payment_view_switch_account_title)
        case .footer:
            return AppTextService.get(AppTextKey.payment_view_header_title)
        }
    }

    func paymentSectionSubtitles(for paymentItem: PaymentSection) -> String? {
        switch paymentItem {
        case .prepared:
            return AppTextService.get(AppTextKey.payment_view_prepared_subtitle)
        case .impact:
            return AppTextService.get(AppTextKey.payment_view_impact_subtitle)
        case .grow:
            return AppTextService.get(AppTextKey.payment_view_grow_subtitle)
        case .data:
            return AppTextService.get(AppTextKey.payment_view_data_subtitle)
        case .switchAccount:
            return AppTextService.get(AppTextKey.payment_view_switch_account_subtitle)
        case .footer:
            return AppTextService.get(AppTextKey.payment_view_footer_subtitle)
        }
    }
}
