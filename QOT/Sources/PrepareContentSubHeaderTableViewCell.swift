//
//  PrepareContentSubHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 23.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PrepareContentSubHeaderTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configure(title: String) {
        titleLabel.attributedText = NSMutableAttributedString(string: title,
                                                              letterSpacing: 2,
                                                              font: Font.H5SecondaryHeadline,
                                                              textColor: .nightModeBlack40,
                                                              alignment: .left)
    }
}
