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
        ThemeText.paymentReminderCellSubtitle.apply(title, to: infoLabel)
        ThemableButton.lightButton.apply(contactButton, title: buttonTitle)
    }

    @IBAction func didTapContactButton(_ sender: UIButton) {
        self.delegate?.didTapContactButton()
    }
}
