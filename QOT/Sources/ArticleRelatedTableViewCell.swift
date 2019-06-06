//
//  ArticleRelatedTableViewCell.swift
//  QOT
//
//  Created by karmic on 24.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ArticleRelatedTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    func configure(title: String, durationString: String, icon: UIImage?) {
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       letterSpacing: 0.5,
                                                       font: .sfProtextLight(ofSize: 16),
                                                       lineSpacing: 1,
                                                       textColor: colorMode.text,
                                                       alignment: .left)
        detailLabel.attributedText = NSAttributedString(string: durationString,
                                                        letterSpacing: 0.5,
                                                        font: .sfProtextMedium(ofSize: 12),
                                                        textColor: colorMode.text.withAlphaComponent(0.3),
                                                        alignment: .left)
        iconImageView.image = icon
        contentView.backgroundColor = colorMode.background
    }
}

final class ArticleNextUpTableViewCell: ArticleRelatedTableViewCell {

    // MARK: - Properties

    @IBOutlet private weak var headerLabel: UILabel!

    func configure(header: String, title: String, durationString: String, icon: UIImage?) {
        super.configure(title: title, durationString: durationString, icon: icon)
        headerLabel.attributedText = NSAttributedString(string: header,
                                                       letterSpacing: 0.5,
                                                       font: .sfProtextMedium(ofSize: 16),
                                                       lineSpacing: 1,
                                                       textColor: colorMode.text.withAlphaComponent(0.4),
                                                       alignment: .left)
    }
}
