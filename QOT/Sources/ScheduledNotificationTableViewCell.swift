//
//  ScheduledNotificationTableViewCell.swift
//  QOT
//
//  Created by karmic on 10.01.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ScheduledNotificationTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
