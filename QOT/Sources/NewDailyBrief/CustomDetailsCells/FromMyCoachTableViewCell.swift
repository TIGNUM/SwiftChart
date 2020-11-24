//
//  FromMyCoachTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 24.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class FromMyCoachTableViewCell: BaseDailyBriefCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    func configure(with data: FromMyCoachCellViewModel.FromMyCoachMessage?, hideSeparatorView: Bool) {
        dateLabel.text = data?.date
        messageLabel.text = data?.text
        separatorView.isHidden = hideSeparatorView
    }
}
