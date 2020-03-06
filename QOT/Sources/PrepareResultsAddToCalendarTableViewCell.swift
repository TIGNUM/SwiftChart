//
//  PrepareResultsAddToCalendarTableViewCell.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class PrepareResultsAddToCalendarTableViewCell: UITableViewCell {

    // MARK: - Private
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Configure
    func configure(title: NSAttributedString, subtitle: NSAttributedString) {
        titleLabel.attributedText = title
        subtitleLabel.attributedText = subtitle
    }
}
