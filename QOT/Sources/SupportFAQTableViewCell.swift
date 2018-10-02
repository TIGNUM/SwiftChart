//
//  SupportFAQTableViewCell.swift
//  QOT
//
//  Created by karmic on 02.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class SupportFAQTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        accessoryType = .disclosureIndicator
    }

    func configure(title: NSAttributedString?) {
        titleLabel.attributedText = title
    }
}
