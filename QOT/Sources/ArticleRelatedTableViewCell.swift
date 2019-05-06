//
//  ArticleRelatedTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleRelatedTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    func configure(title: String, durationString: String, icon: UIImage?) {
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       letterSpacing: 0.5,
                                                       font: .apercuLight(ofSize: 16),
                                                       lineSpacing: 8,
                                                       textColor: colorMode.textColor,
                                                       alignment: .left)
        detailLabel.attributedText = NSAttributedString(string: durationString,
                                                        letterSpacing: 0.5,
                                                        font: .apercuMedium(ofSize: 12),
                                                        textColor: colorMode.textColor.withAlphaComponent(0.3),
                                                        alignment: .left)
        iconImageView.image = icon
    }
}
