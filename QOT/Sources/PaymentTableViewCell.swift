//
//  PaymentTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PaymentTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitlelabel: UILabel!
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.paymentReminder.apply(self)
    }

    func configure(title: String?, subtitle: String?) {
        guard let titleText = title, let subtitleText = subtitle else { return }
        ThemeText.paymentReminderCellTitle.apply(titleText.uppercased(), to: titleLabel)
        ThemeText.paymentReminderCellSubtitle.apply(subtitleText, to: subtitlelabel)
    }
}
