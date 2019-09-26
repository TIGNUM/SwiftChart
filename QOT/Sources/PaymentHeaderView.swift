//
//  PaymentHeaderView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PaymentHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    static func instantiateFromNib(title: String?, subtitle: String?) -> PaymentHeaderView {
        guard let headerView = R.nib.paymentHeaderView.instantiate(withOwner: self).first as? PaymentHeaderView else {
            fatalError("Cannot load header view")
        }

        ThemeView.paymentReminder.apply(headerView)
        headerView.configure(title: title, subtitle: subtitle)
        return headerView
    }

    func configure(title: String?, subtitle: String?) {
        guard let titleText = title, let subtitleText = subtitle else { return }
        ThemeText.paymentReminderHeaderTitle.apply(titleText, to: titleLabel)
        ThemeText.paymentReminderHeaderSubtitle.apply(subtitleText, to: subtitleLabel)
    }
}
