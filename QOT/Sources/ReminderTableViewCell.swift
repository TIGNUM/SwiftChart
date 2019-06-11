//
//  ReminderTableViewCell.swift
//  QOT
//
//  Created by karmic on 04.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ReminderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var reminderSwitch: UISwitch!

    func configure(title: String, subTitle: String, isOn: Bool) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        reminderSwitch.isOn = isOn
    }
}
