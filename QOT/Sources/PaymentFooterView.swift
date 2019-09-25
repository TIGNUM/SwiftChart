//
//  PaymentSwitchAccountTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 25/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol PaymentFooterViewDelegate: class {
    func didTapContactButton()
}

final class PaymentFooterView: UITableViewCell, Dequeueable {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var contactButton: RoundedButton!
    weak var delegate: PaymentFooterViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.paymentReminder.apply(self)
    }

    func configure(title: String?, buttonTitle: String?) {
        guard let titleText = title, let buttonText = buttonTitle else {
            return
        }
        ThemeText.paymentReminderCellSubtitle.apply(titleText, to: infoLabel)
        ThemableButton.paymentReminder.apply(contactButton, title: buttonText)
    }

    @IBAction func didTapContactButton(_ sender: UIButton) {
        self.delegate?.didTapContactButton()
    }
}
