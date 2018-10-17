//
//  PrepareNotesTableViewCell.swift
//  QOT
//
//  Created by karmic on 05.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PrepareNotesTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configure(title: String) {
        titleLabel.attributedText = NSMutableAttributedString(string: title,
                                                              letterSpacing: 2,
                                                              font: .PText,
                                                              lineSpacing: 10,
                                                              textColor: .nightModeBlack,
                                                              alignment: .left)
    }
}
