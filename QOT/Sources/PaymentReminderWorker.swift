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
        let headerTitle = isExpired ? AppTextService.get(AppTextKey.generic_payment_screen_expired_section_header_title_header_expired) : AppTextService.get(AppTextKey.generic_payment_screen_expire_soon_section_header_title_header)
        let headerSubtitle = isExpired ? AppTextService.get(AppTextKey.generic_payment_screen_expired_section_header_subtitle_header_expired) : AppTextService.get(AppTextKey.generic_payment_screen_expire_soon_section_header_subtitle_header)
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
            return AppTextService.get(AppTextKey.generic_payment_screen_section_one_title_prepared)
        case .impact:
            return AppTextService.get(AppTextKey.generic_payment_screen_section_two_title_impact)
        case .grow:
            return AppTextService.get(AppTextKey.generic_payment_screen_section_three_title_grow)
        case .data:
            return AppTextService.get(AppTextKey.generic_payment_screen_expire_soon_section_header_title_header)
        case .switchAccount:
            return AppTextService.get(AppTextKey.generic_payment_screen_section_four_title_data)
        case .footer:
            return AppTextService.get(AppTextKey.generic_payment_screen_expire_soon_section_header_title_header)
        }
    }

    func paymentSectionSubtitles(for paymentItem: PaymentSection) -> String? {
        switch paymentItem {
        case .prepared:
            return AppTextService.get(AppTextKey.generic_payment_screen_section_one_subtitle_prepared)
        case .impact:
            return AppTextService.get(AppTextKey.generic_payment_screen_section_two_subtitle_impact)
        case .grow:
            return AppTextService.get(AppTextKey.generic_payment_screen_section_three_subtitle_grow)
        case .data:
            return AppTextService.get(AppTextKey.generic_payment_screen_section_four_subtitle_data)
        case .switchAccount:
            return AppTextService.get(AppTextKey.generic_payment_screen_expired_section_footer_subtitle_switch_account)
        case .footer:
            return AppTextService.get(AppTextKey.generic_payment_screen_section_footer_subtitle_footer)
        }
    }
}
