//
//  TriggerTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MindsetShifterHeaderCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Configuration

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
