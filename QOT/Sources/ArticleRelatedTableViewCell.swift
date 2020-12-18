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

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = UIView()
    }

    func configure(title: String, durationString: String, icon: UIImage?) {
        ThemeText.articleRelatedTitle(nil).apply(title.uppercased(), to: titleLabel)
        ThemeText.articleRelatedDetail(nil).apply(durationString, to: detailLabel)
        iconImageView.image = icon
        iconImageView.tintColor = colorMode == .dark ? .darkGray : .lightGray
        contentView.backgroundColor = colorMode.background
        selectedBackgroundView?.backgroundColor = colorMode.cellHighlight
    }
}

final class ArticleNextUpTableViewCell: ArticleRelatedTableViewCell {

    // MARK: - Properties

    @IBOutlet private weak var headerLabel: UILabel!

    func configure(header: String, title: String, durationString: String, icon: UIImage?) {
        super.configure(title: title, durationString: durationString, icon: icon)
        ThemeText.articleNextTitle.apply(header, to: headerLabel)
    }
}
