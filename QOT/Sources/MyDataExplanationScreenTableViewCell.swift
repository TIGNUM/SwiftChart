//
//  MyDataExplanationScreenTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MyDataExplanationScreenTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    func configure(title: String?, subtitle: String?) {
        guard let title = title, let subtitle = subtitle else { return }
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       letterSpacing: 0.2,
                                                       font: .sfProtextSemibold(ofSize: 14),
                                                       lineSpacing: 6,
                                                       textColor: .sand,
                                                       alignment: .left)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                          letterSpacing: 0,
                                                          font: .sfProtextRegular(ofSize: 14),
                                                          lineSpacing: 9,
                                                          textColor: .sand60,
                                                          alignment: .left)
    }
}
