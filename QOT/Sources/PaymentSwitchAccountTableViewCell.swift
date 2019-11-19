//
//  PaymentSwitchAccountTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 25/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol PaymentSwitchAccountTableViewCellDelegate: class {
    func didTapSwitchAccountButton()
}

final class PaymentSwitchAccountTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var switchAccountButton: UIButton!
    weak var delegate: PaymentSwitchAccountTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.paymentReminder.apply(self)
    }

    func configure(title: String?, buttonTitle: String?) {
        ThemeText.paymentReminderCellSubtitle.apply(title, to: signInLabel)
        switchAccountButton.setTitle(buttonTitle, for: .normal)
        switchAccountButton.setTitleColor(.accent, for: .normal)
        switchAccountButton.setTitleColor(.accent40, for: .highlighted)
    }

    @IBAction func didTapSwitchAccountButton(_ sender: UIButton) {
        delegate?.didTapSwitchAccountButton()
    }
}
