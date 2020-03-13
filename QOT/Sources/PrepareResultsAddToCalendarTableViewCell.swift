//
//  PrepareResultsAddToCalendarTableViewCell.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class PrepareResultsAddToCalendarTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Private
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Configure
    func configure(title: String, subtitle: String) {
        //FIXME: https://tignum.atlassian.net/browse/QOT-2688
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       font: UIFont.sfProtextMedium(ofSize: 24),
                                                       textColor: .carbon,
                                                       alignment: .left)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                          font: UIFont.sfProtextRegular(ofSize: 12),
                                                          textColor: .accent,
                                                          alignment: .left)
    }
}
